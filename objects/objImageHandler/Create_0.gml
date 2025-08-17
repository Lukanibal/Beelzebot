///handle images

current_image := -1;

message := "";


image_type := ".png";

images := [];

function img_num()
{
	return array_length(objImageHandler.images);
}


resize := -1;