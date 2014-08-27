function setImage(){
var imgs = document.getElementsByTagName("img");
for (var i=0;i<imgs.length;i++){
    var src = imgs[i].src;
    imgs[i].setAttribute("onClick","imageClick(src)");
}
    document.location = imageurls;
}

function imageClick(imagesrc){
    var url="imageClick:"+imagesrc;
    document.location = url;
}