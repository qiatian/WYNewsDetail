window.onload = function(){
//    alert(0);
    //拿到所有的图片
    var allImg = document.getElementsByTagName("img");
    
    //遍历
    for (var i=0;i<allImg.length;i++){
        //取出单个图片对象
        var img = allImg[i];
        img.id = i;
        //监听点击
        img.onclick = function(){
//            alert('点击了第'+this.id+'张');
            //跳转
//            window.location.href = "http://www.baidu.com";
            window.location.href = "llq://openCamera";
        }
    }
    //往网页底部加一个图片
    var img = document.createElement('img')
    img.src = 'http://www.520it.com/userfiles/1/images/cms/site/2015/09/index_06.jpg';
    document.body.appendChild(img);
}
