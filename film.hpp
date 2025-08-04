#pragma once
#include <sys/platform.h>
#include <sys/sysinfo.h>
#include <sys/alloc.h>

#include <sys/ref.h>
#include <sys/vector.h>
#include <math/vec2.h>
#include <math/vec3.h>
#include <math/vec4.h>
#include <math/bbox.h>
#include <math/lbbox.h>
#include <math/affinespace.h>
#include <sys/filename.h>
#include <sys/estring.h>
#include <lexers/tokenstream.h>
#include <lexers/streamfilters.h>
#include <lexers/parsestream.h>
#include <atomic>

#include <sstream>
#include <vector>
#include <memory>
#include <map>
#include <set>
#include <deque>

#include "helper.hpp"

#include <sys/sysinfo.h>

#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include <imgui.h>
#include <imgui_impl_glfw.h>
#include <imgui_impl_opengl3.h>

#include "camera.hpp"
#include "ray.hpp"
#include "random_sampler.hpp"
#include "random_sampler_wrapper.hpp"


inline unsigned int packColor(unsigned int r, unsigned int g, unsigned int b) {
	return (b << 16) + (g << 8) + r;
}

#include <atomic>

// AtomicFloat Class
class AtomicFloat {
public:
	// AtomicFloat Public Methods
	explicit AtomicFloat(float v = 0.0f) {
		bits = floatToBits(v);
	}



	operator float() const {
		return bitsToFloat(bits);
	}

	float operator=(float v) {
		bits = floatToBits(v);
		return v;
	}

	void add(float v) {
		uint32_t oldBits = bits, newBits;
		do {
			newBits = floatToBits(bitsToFloat(oldBits) + v);
		} while (!bits.compare_exchange_weak(oldBits, newBits));
	}

private:
	// AtomicFloat Private Data
	std::atomic<uint32_t> bits;

	// Helper functions to convert between float and uint32_t
	static uint32_t floatToBits(float f) {
		uint32_t u;
		memcpy(&u, &f, sizeof(uint32_t));
		return u;
	}

	static float bitsToFloat(uint32_t u) {
		float f;
		memcpy(&f, &u, sizeof(uint32_t));
		return f;
	}
};

class Film {
public:
	Film() {

	}

	Film(unsigned int width, unsigned int height)
	{
		init(width, height);
	}

	void init(unsigned int w, unsigned int h) {
		width = w;
		height = h;

		size_t size = width * height;
		accu_x = std::make_unique<AtomicFloat[]>(size);
		accu_y = std::make_unique<AtomicFloat[]>(size);
		accu_z = std::make_unique<AtomicFloat[]>(size);
		splat_count = std::make_unique<std::atomic<unsigned int>[]>(size);
		clear();
	}

	// atomic safe
	void addSplat(int x, int y, const Vec3fa& value) {
		size_t index = y * width + x;
		accu_x[index].add(value.x);
		accu_y[index].add(value.y);
		accu_z[index].add(value.z);
		if(count)
			splat_count[index].fetch_add(1, std::memory_order_relaxed);
	}


	void writeToFramebuffer(unsigned int* pixels) {

		parallel_for(size_t(0), size_t(width * height), [&](const range<size_t>& range) {
			for (size_t i = range.begin(); i < range.end(); ++i) {
				pixels[i] = getPackedColor(i);			
			}
		});
	}

	unsigned int getPackedColor(size_t index) const {

		float divider = 1.0;

		if (count) {
			unsigned int count = splat_count[index].load(std::memory_order_relaxed);
			if (count == 0) return 0; // Return black if no splats
			divider = 1.0 / count;
		}


		
		float accu_x_val = accu_x[index] *divider* scalar;
		float accu_y_val = accu_y[index] * divider* scalar;
		float accu_z_val = accu_z[index] * divider* scalar;

		unsigned int r = static_cast<unsigned int>(255.01f * clamp(accu_x_val, 0.0f, 1.0f));
		unsigned int g = static_cast<unsigned int>(255.01f * clamp(accu_y_val, 0.0f, 1.0f));
		unsigned int b = static_cast<unsigned int>(255.01f * clamp(accu_z_val, 0.0f, 1.0f));

		return packColor(r, g, b);
	}

	unsigned int getPackedColor(int x, int y) const {
		return getPackedColor(y * width + x);
	}

	void clear() {
		parallel_for(size_t(0), size_t(width * height), [&](const range<size_t>& range) {
			for (size_t i = range.begin(); i < range.end(); ++i) {
				accu_x[i] = 0.0f;
				accu_y[i] = 0.0f;
				accu_z[i] = 0.0f;
				splat_count[i].store(0, std::memory_order_relaxed);
			}
		});
	}


	float scalar = 1.0;
	unsigned int width, height;
	bool count = true;
private:
	std::unique_ptr<AtomicFloat[]> accu_x, accu_y, accu_z;

	std::unique_ptr<std::atomic<unsigned int>[]> splat_count;

};