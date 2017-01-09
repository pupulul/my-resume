$(document).ready(function(){
	fresh();
	$(".switch>li").each(function(index){
		var node = $(this);
		node.click(function(){
			$(".switch>li").removeClass("active");
			node.addClass("active");
			$("body>div").css("display","none");
			$("body>div").eq(index).css("display","block");
		});
	});
});

// function new() {
// 	// $("#contact").css("display","none");
// };
function fresh (){
	console.log(1);
	$("#contact").css("display","none");
};