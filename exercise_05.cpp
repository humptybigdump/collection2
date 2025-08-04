#include <cglib/rt/renderer.h>

#include <cglib/rt/epsilon.h>
#include <cglib/rt/intersection.h>
#include <cglib/rt/object.h>
#include <cglib/rt/light.h>
#include <cglib/rt/ray.h>
#include <cglib/rt/raytracing_context.h>
#include <cglib/rt/render_data.h>
#include <cglib/rt/scene.h>
#include <cglib/core/glmstream.h>
#include <exception>
#include <stdexcept>

#include <cglib/core/thread_local_data.h>

// returns a random unformly distributed point on the light source
glm::vec3 AreaLight::uniform_sample_point(float x0, float x1) const
{
	return position + x0 * tangent + x1 * bitangent;
}


/*
 * Creates a random sample on a unit disk
 *
 * Parameters:
 * - u1: random number [0,1)
 * - u2: random number [0,1)
 */
glm::vec2
uniform_sample_disk(float u1, float u2)
{
	// TODO DOF: implement uniform sampling on a unit disk here
	return glm::vec2(0.0);
}

/*
 * Creates a random sample on a unit sphere
 *
 * Parameters:
 * - u1: random number [0,1)
 * - u2: random number [0,1)
 */
glm::vec3
uniform_sample_sphere(float u1, float u2)
{
	// TODO AmbientOcclusion/IndirectIllumination: 
	// implement uniform sampling on a unit sphere
	return glm::vec3(0.0);
}

/*
 * Creates a random sample on a hemisphere with
 * normal direction N
 *
 * Parameters:
 * - data: RenderData for access to random number generator
 * - N: main direction of the hemisphere
 */
glm::vec3
uniform_sample_hemisphere(RenderData & data, glm::vec3 const& N)
{
	// TODO AmbientOcclusion/IndirectIllumination: 
	// implement uniform sampling on a unit hemisphere.
	// data.tld->rand() creates uniform [0, 1] random numbers
	// TIP: use uniform_sample_sphere 
	return glm::vec3(0.0);
}


glm::vec3 trace_recursive_with_lens(RenderData & data, Ray const& ray, int depth)
{
	glm::vec3 contribution(0.0f);

	if (data.context.params.dof && data.context.params.dof_rays > 0)
	{
		// TODO DOF: compute point on focus plane that is common to all rays of this pixel

		// TODO DOF: sample random points on the lens

			// TODO DOF: generate ray from the sampled point on the
			// lens through the common point in the focus plane
			// TODO DOF: start ray tracing with the new lens ray

		// TODO DOF: compute average contribution of all lens rays
	}
	else
		contribution = trace_recursive(data, ray, depth);

	return contribution;
}

float evaluate_ambient_occlusion(
	RenderData &data,           // class containing raytracing information
	glm::vec3 const& P,         // world space position
	glm::vec3 const& N)         // normal at the position (already normalized)
{
	// TODO AmbientOcclusion: compute ambient occlusion
	float ambient_occlusion = 0.f;
	for (int i = 0; i < data.context.params.ao_rays; ++i) {
	}

	return ambient_occlusion;
}

glm::vec3 evaluate_illumination_from_light(
	RenderData &data,           // class containing raytracing information
	MaterialSample const& mat,  // the material at position
	Light const& light,         // the light source
	glm::vec3 const& LP,        // a point on the light source
	glm::vec3 const& P,         // world space position
	glm::vec3 const& N,         // normal at the position (already normalized)
	glm::vec3 const& V)         // view vector (already normalized)
{
	glm::vec3 L = LP - P;                       // direction to the light
	const float dist2 = glm::dot(L, L);         // compute squared distance to light point
	L /= sqrt(dist2);                           // normalize direction

	float visibility = 1.f;
	if (data.context.params.shadows) {
		if (!visible(data, P, LP)) {
			visibility = 0.f;
		}
	}	

	auto incomingLight = visibility * light.getEmission(-L) / dist2;
	return evaluate_phong_BRDF(data, mat, L, N, V) * incomingLight;
}

glm::vec3 evaluate_illumination(
	RenderData &data,           // class containing raytracing information
	MaterialSample const& mat,  // the material at position
	glm::vec3 const& P,         // world space position
	glm::vec3 const& N,         // normal at the position (already normalized)
	glm::vec3 const& V,         // view vector (already normalized)
	int depth)                  // the current recursion depth
{
	glm::vec3 direct_illumination(0.f);
	if (!data.context.params.disable_direct || depth > 1)
	{
        {
			for (auto& light : data.context.get_active_scene()->lights) {
				const glm::vec3 LP = light->getPosition();
				direct_illumination += evaluate_illumination_from_light(
						data, mat, *light, LP, P, N, V);
			}
			direct_illumination /= data.context.get_active_scene()->lights.size();
		}
	}

	glm::vec3 indirect_illumination(0.f);
	if (data.context.params.indirect) 
	{
		// TODO IndirectIllumination: compute indirect illumination
	}

	return direct_illumination + indirect_illumination;
}
// CG_REVISION cf19ad39f6041ea8c1e7b55d2580a46744918fcd
