/*
curl -X POST http://localhost:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "a futuristic cityscape",
    "negative_prompt": "blurry, low quality",
    "num_inference_steps": 30,
    "guidance_scale": 7.5,
    "width": 1024,
    "height": 1024
  }' \
  --output image.png
*/


global.painting := -1;
/*function paint( _request)
{
	//var _header := ds_map_create();
	//ds_map_set(_header, "Content-Type", "application/json");
	
	var _prompt2 := 
	{
		"prompt": $"{_request}",
	    "negative_prompt": "lowres, text, error, cropped, worst quality, low quality, jpeg artifacts, ugly, duplicate, morbid, mutilated, out of frame, extra fingers, mutated hands, poorly drawn hands, poorly drawn face, mutation, deformed, blurry, dehydrated, bad anatomy, bad proportions, extra limbs, cloned face, disfigured, gross proportions, malformed limbs, missing arms, missing legs, extra arms, extra legs, fused fingers, too many fingers, long neck, username, watermark, signature ",
	    "num_inference_steps": 50,
	    "guidance_scale": 7.5,
	    "width": 512,
	    "height": 512
	}
	
	var _prompt :=
	{
	  "prompt": $"\"{_request}\"",
	  "negative_prompt": "low quality, bad anatomy, worst quality, low resolution",
	  "num_inference_steps": 50,
	  "steps": 0,
	  "guidance_scale": 7.5,
	  "cfg_scale": 0,
	  "width": 512,
	  "height": 512,
	  "control_image_path": "string",
	  "controlnet_conditioning_scale": 1,
	  "control_guidance_start": 0,
	  "control_guidance_end": 1
	}
	
	global.painting := http_post_string("http://localhost:8000/api/generate?", json_stringify(_prompt));
	
	//global.painting := http_request("http://localhost:8000/api/generate", "POST", _header, json_stringify(_prompt));
	//ds_map_destroy(_header);
}
*/




function paint( _request)
{
	show_debug_message(_request);
	shutdown_llm();
	var _test := painter_paint(_request);
	if(_test == 0)
	{

		global.painting := upload_painting(_request)
	}
}
/*
{"detail":[{"type":"model_attributes_type","loc":["body"],"msg":"Input should be a valid dictionary or object to extract fields from","input":"{\"negative_prompt\":\"lowres, text, error, cropped, worst quality, low quality, jpeg artifacts, ugly, duplicate, morbid, mutilated, out of frame, extra fingers, mutated hands, poorly drawn hands, poorly drawn face, mutation, deformed, blurry, dehydrated, bad anatomy, bad proportions, extra limbs, cloned face, disfigured, gross proportions, malformed limbs, missing arms, missing legs, extra arms, extra legs, fused fingers, too many fingers, long neck, username, watermark, signature \",\"num_inference_steps\":50.0,\"guidance_scale\":7.5,\"height\":512.0,\"prompt\":\"  llama\",\"width\":512.0}"}]}