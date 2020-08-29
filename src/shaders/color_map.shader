shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform bool activated = true;

uniform vec2 texture_map_size;

uniform sampler2D texture_grey_map;

uniform sampler2D texture_color_map;


vec3 map_to_color(vec3 grey_color){
	vec3 color = grey_color;
	if (activated){
		vec2 pixel_size = 1.0/texture_map_size;
		for (int pos=0;pos<int(1.0/pixel_size.x);pos++){
			vec4 a_current_grey_color=texture(texture_grey_map,vec2(float(pos)*pixel_size.x,0.0));
			if (a_current_grey_color.a > 0.0 ){
				vec3 current_grey_color = a_current_grey_color.rgb;
				
				if (current_grey_color == grey_color){
					vec4 a_color = texture(texture_color_map, vec2(float(pos)*pixel_size.x,0.0));
					if (a_color.a > 0.0){
						color = a_color.rgb;
					}
				}
			}
			
		}
	}
	
	
	return color;
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo,UV);
	ALBEDO = map_to_color(albedo.rgb * albedo_tex.rgb);
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}
