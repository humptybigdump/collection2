// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

#pragma once
#include "scenegraph.h"

namespace embree
{

	class Grid {
	private:
		std::vector<float> data;
		Vec3ia res;
		Vec3fa worldPos, scale;

	public:
		Grid(const std::string& filePath, const Vec3ia res, const Vec3fa& worldPos, const Vec3fa& scale)
			: res(res), worldPos(worldPos), scale(scale) {
			loadVolume(filePath);
		}



			// Check if the point is inside the box
		bool isInside(Vec3fa point) {
			
			Vec3fa maxExtent = worldPos + scale;

			return (point.x >= worldPos.x && point.x <= maxExtent.x &&
				point.y >= worldPos.y && point.y <= maxExtent.y &&
				point.z >= worldPos.z && point.z <= maxExtent.z);
		}

		bool intersect(Vec3fa rayOrigin, Vec3fa rayDir, Vec2fa& resT) {
			Vec3fa boxMin = worldPos;
			Vec3fa boxMax = worldPos + scale;

			Vec3fa tMin = (boxMin - rayOrigin) / rayDir;
			Vec3fa tMax = (boxMax - rayOrigin) / rayDir;
			Vec3fa t1 = min(tMin, tMax);
			Vec3fa t2 = max(tMin, tMax);
			float tNear = max(max(t1.x, t1.y), t1.z);
			float tFar = min(min(t2.x, t2.y), t2.z);
			resT = Vec2fa(tNear, tFar);

			return resT.y > resT.x;
		};

		void loadVolume(const std::string& filePath) {
			std::ifstream file(filePath, std::ios::binary);
			if (!file) {
				throw std::runtime_error("Failed to open the file.");
			}

			data.resize(res.x * res.y * res.z);
			file.read(reinterpret_cast<char*>(data.data()), data.size() * sizeof(float));
			file.close();
		}


		// return -1.0f if the point is out of the bounding box
		float sampleW(const Vec3fa& worldPos) const {
			// Convert world position to local position
			Vec3fa localPos = (worldPos - this->worldPos) / scale;

			if (localPos.x < 0.0 || localPos.y < 0.0 || localPos.z < 0.0 || localPos.x > 1.0 || localPos.z > 1.0 || localPos.y > 1.0) {
				return -1.0f;
			}
			
			return sample(localPos);
		}

	private:
		

		float get(int index) const {
			assert(index > 0 && index < res.x * res.y * res.z);
			return data[index];
		}



		float get(const Vec3ia& p) const {
			// Clamp the coordinates to the nearest valid value within the grid bounds
			int clampedX = std::max(0, std::min(p.x, res.x - 1));
			int clampedY = std::max(0, std::min(p.y, res.y - 1));
			int clampedZ = std::max(0, std::min(p.z, res.z - 1));

			return data[clampedX + res.x * clampedY + res.x*res.y * clampedZ];
		}


		float sample(Vec3fa pos) const {
			pos.x *= res.x-1;
			pos.y *= res.y - 1;
			pos.z *= res.z - 1;

			int ix = static_cast<int>(std::floor(pos.x));
			int iy = static_cast<int>(std::floor(pos.y));
			int iz = static_cast<int>(std::floor(pos.z));

			float fx = pos.x - ix;
			float fy = pos.y - iy;
			float fz = pos.z - iz;

			// Fetch values from the eight surrounding corners
			Vec3ia p000(ix, iy, iz);
			Vec3ia p001(ix, iy, iz + 1);
			Vec3ia p010(ix, iy + 1, iz);
			Vec3ia p011(ix, iy + 1, iz + 1);
			Vec3ia p100(ix + 1, iy, iz);
			Vec3ia p101(ix + 1, iy, iz + 1);
			Vec3ia p110(ix + 1, iy + 1, iz);
			Vec3ia p111(ix + 1, iy + 1, iz + 1);

			// Trilinear interpolation
			float c000 = get(p000);
			float c001 = get(p001);
			float c010 = get(p010);
			float c011 = get(p011);
			float c100 = get(p100);
			float c101 = get(p101);
			float c110 = get(p110);
			float c111 = get(p111);

			float c00 = c000 * (1 - fz) + c001 * fz;
			float c01 = c010 * (1 - fz) + c011 * fz;
			float c10 = c100 * (1 - fz) + c101 * fz;
			float c11 = c110 * (1 - fz) + c111 * fz;

			float c0 = c00 * (1 - fy) + c01 * fy;
			float c1 = c10 * (1 - fy) + c11 * fy;

			float c = c0 * (1 - fx) + c1 * fx;
			return c;
		}
	};
}
