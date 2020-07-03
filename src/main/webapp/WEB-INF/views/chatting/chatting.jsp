<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="../header/cdn.jsp"></jsp:include>

<link rel="stylesheet" href="resources/css/chatting/chatting.css?after" />

<!-- 코드 편집기 CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.13.1/styles/agate.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"></script> 
<script>hljs.initHighlightingOnLoad();</script>

<script>
	$(function(){
		updateScroll();
		
		var ws = new WebSocket("ws://localhost/chat");  //이 url에 소켓 연결을 요청하고, WebChat 클래스가 요청을 받음
		
		ws.onmessage = function(e){
			
			var msg = JSON.parse(e.data);
						
			var id = msg.id;
			var text = msg.text;
			var date = msg.date;
			var time = msg.time;
			
			var chat_box = $("<div class='chat_box'>");
			var profile = $("<div class='profile'>");
			var profile_img = $("<img src='resources/images/chatting/profile.png' class='profile_img'>");
			
			profile.append(profile_img);
			
			var chat_box_in = $("<div class='chat_box_in'>");
			var name = $("<div class='name'>");
			var chat = $("<div class='chat'>");
			var timediv = $("<div class='time'>");
			
			name.append(id);
			chat.append(text);
			timediv.append(time);
			
			chat_box_in.append(name);
			chat_box_in.append(chat);
			chat_box_in.append(timediv);
			
			chat_box.append(profile);
			chat_box.append(chat_box_in);
			
			console.log(text);
			
			$(".chat_section").append(chat_box);
			
			updateScroll();
			
		}
		
		//엔터 버튼
		$("#input").keydown(function(e){
			if(e.keyCode == 13){  //13번 = 엔터키
				
				var d = new Date();
				
				var week = ["일","월","화","수","목","금","토"];
				var day = week[d.getDay()];
				
				var fulldate = d.toLocaleString();
				var date = d.getFullYear()+"년 "+(d.getMonth()+1)+"월 "+d.getDate()+"일 "+day+"요일";
				var time = d.toLocaleTimeString();
				
				var msg = {
					type: "message",
					text: $("#input").html(),
					fulldate: fulldate,
					date: date,
					time: time
				};
				
				ws.send(JSON.stringify(msg));  //json 데이터 string으로 보내기
				
				updateScroll();
				$("#input").html("");
				
				return false; //엔터쳤을때 커서가 아래로 떨어지지 않게 막아줌
			}
		})
		
		
		//전송 버튼
		$("#send_btn").on("click", function(){

			var d = new Date();
			
			var week = ["일","월","화","수","목","금","토"];
			var day = week[d.getDay()];
			
			var fulldate = d.toLocaleString();
			var date = d.getFullYear()+"년 "+(d.getMonth()+1)+"월 "+d.getDate()+"일 "+day+"요일";
			var time = d.toLocaleTimeString();
			
			var msg = {
				type: "message",
				text: $("#input").html(),
				fulldate: fulldate,
				date: date,
				time: time
			};
			
			ws.send(JSON.stringify(msg));
			
			
			
			//formdata로 보내기
			//var form = new FormData(document.getElementById('fileForm'));
			
			//ws.send(form);
			
			
			
			updateScroll();
			$("#input").html("");
			
			return false;
		})
		
		
		function updateScroll(){
			var element = document.getElementById("chat_section");
			element.scrollTop = element.scrollHeight;
		}
		
		
		var num = 2;
		//스크롤 위로 갈 시 이전 데이터 불러오기
		$("#chat_section").on("scroll", function(){
			
			if($("#chat_section").scrollTop() == 0){
				
				$.ajax({
					url : "lastChat",
					type : "post",
					data : {
						num : num
					},
					dataType : "json"

				}).done(function(response) {
					
					//대화 내용 먼저 출력
					for (var i = 0; i < response.length; i++) {
						
						var id = response[i].writer;
						var text = response[i].chat;
						var time = response[i].time;
						
						var chat_box = $("<div class='chat_box'>");
						var profile = $("<div class='profile'>");
						var profile_img = $("<img src='resources/images/chatting/profile.png' class='profile_img'>");
						
						profile.append(profile_img);
						
						var chat_box_in = $("<div class='chat_box_in'>");
						var name = $("<div class='name'>");
						var chat = $("<div class='chat'>");
						var timediv = $("<div class='time'>");
						
						name.append(id);
						chat.append(text);
						timediv.append(time);
						
						chat_box_in.append(name);
						chat_box_in.append(chat);
						chat_box_in.append(timediv);
						
						chat_box.append(profile);
						chat_box.append(chat_box_in);
						
						$(".chat_section").prepend(chat_box);
					}
					
					//해당 날짜 출력
					var date = response[0].form_date;
					
					var chat_section = $("<div class='chat_section' id=chat_section>");
					var chat_date_box = $("<div class=chat_date_box>");
					var chat_date_btn = $("<button class=chat_date_btn>");
					
					chat_date_btn.append(date);
					chat_date_box.append(chat_date_btn);
					
					$(".chat_section").prepend(chat_date_box);  //맨위에 올라가는게 가장 마지막에!
					
					num = num+1;  //날짜 +1
				})
				
			}
		})
		
		//마우스 우클릭 브라우저 기본이벤트 변경
		var chat_id = "";
		$(".chat").on('contextmenu', function() {
			
			chat_id = $(this).attr("id");
			
			$(".chat_section").css("overflow-y", "hidden");  //스크롤 방지

			event.stopPropagation();
			event.preventDefault();

			x = event.pageX;
			y = event.pageY;

			$("#contextmenu").css("margin-top", y + 1 + "px");
			$("#contextmenu").css("margin-left", x + 1 + "px");
			$("#contextmenu").css("display", "block");
			
		});
		
		
		//챗 우클릭 후 이외 공간 클릭시
		$(document).on("click", function(){
			$("#contextmenu").css("display", "none");
			$(".chat_section").css("overflow-y", "auto");
        })
		
        
        //대화 삭제
        $(".delete_chat").on("click", function(){
        	// chat_id = 지금 클릭한 챗
        	//먼저 팝업창 띄우고, 예 누르면 ajax로 삭제 실행
        	
        	$.ajax({
        		url: "deleteChat",
        		type: "post",
        		data: {seq: chat_id}
        		
        	}).done(function(response){
        		
        		if(response==1){
        			//id가 chat_id인 애를 화면에서 삭제!
            		$("#"+chat_id).parent().parent().remove();
            		alert("삭제되었습니다.");
        		}
        	})
        })
        
        
        //이모티콘 박스 보이기
        $(".emoticon_icon").on("click", function(){
        	$(".emoticon_section").toggle();
        })
        
        
        //이모티콘 선택하면 div에 넣기
        $(".emoticon_box>.emoticon").on("click", function(){
        	$(".emoticon_section").hide();
        	
        	var emoticon_id = $(this).attr("id");
        	$("#input").append("<img src=resources/images/chatting/"+emoticon_id+" class=emoticon id="+emoticon_id+"><br>");
        	
        	//자동줄바꿈 추가하기!
        	
        })
        
        
        //코드 편집기 열기
        var code_index = 1;
        $(".code_icon").on("click",function(){
        	if($("#input").html().indexOf("</code></pre>") == -1){  //이 코드가 없다면
                $("#input").append("<pre class=pre><code class=code_editor></code></pre>");
                
                $("#input>.pre").css("display","block");
                $("#input>.pre>.code_editor").css("display","block");
                
            }else if(code_index == 1){
                $("#input>.pre").css("display","block");
                $("#input>.pre>.code_editor").css("display","block");
                code_index = code_index*-1;
            }else{
                $("#input>.pre").css("display","none");
                $("#input>.pre>.code_editor").css("display","none");
                $("#input>.pre>.code_editor").html("");
                code_index = code_index*-1;
            }
        })
        
        
        
        
        
        //이모티콘박스 이외 부분 클릭시 이모티콘박스 닫히기 추가하기!!!
        
        
	})
</script>

</head>

<body>

	<div id=contextmenu>
		<div class="c_menu delete_chat">삭제</div>
		<div class="c_menu reply_chat">답장</div>
		<div class="c_menu copy_chat">복사</div>
		<div class="c_menu deliver_chat">전달</div>
		<div class="c_menu post_chat">공지</div>
	</div>

	<!-- Header -->
	<jsp:include page="../header/header.jsp"></jsp:include>
	<!-- 왼쪽 사이드바 -->
	<jsp:include page="../header/sidebar-left.jsp"></jsp:include>

	<section>
		<div id="container">
			<!-- 여기부터 각자 영역 설정 -->
			
				<!-- 채팅 타이틀 -->
                <div class="chat_title_section">
                    <div class=chat_title>KH 파이널 5조</div>
                    <div class=chat_person_num>
                    	<img src="resources/images/chatting/user.png" class=chat_person_img>5
                    </div>
                </div>
                
                <!-- 채팅창 -->
                <div class="chat_section" id=chat_section>
                
                    <!-- 채팅 날짜 (어제) -->
                    <div class=chat_date_box>
                        <button class=chat_date_btn>${yesterday}</button>
                    </div>
                    
                    <!-- 대화 내용 (어제) -->
                    <c:forEach var="i" items="${yesterdayChat}">
                    	<div class=chat_box>
                        	<div class=profile>
                            	<img src=resources/images/chatting/profile.png class=profile_img>
                        	</div>
                        	<div class=chat_box_in>
                            	<div class=name>${i.writer}</div>
                            	<div class=chat id="${i.seq}">${i.chat}</div>
                            	<div class=time>${i.time}</div>
                        	</div>
                    	</div>
                    </c:forEach>
                    
                    
                    <!-- 채팅 날짜 (오늘) -->
                    <div class=chat_date_box>
                        <button class=chat_date_btn>${today}</button>
                    </div>
                    
                    <!-- 대화 내용 (오늘) -->
                    <c:forEach var="i" items="${todayChat}">
                    	<div class=chat_box>
                        	<div class=profile>
                            	<img src=resources/images/chatting/profile.png class=profile_img>
                        	</div>
                        	<div class=chat_box_in>
                            	<div class=name>${i.writer}</div>
                            	<div class=chat id="${i.seq}">${i.chat}</div>
                            	<div class=time>${i.time}</div>
                        	</div>
                    	</div>
                    </c:forEach>
                    
                    
                    
                </div>
                
                
                <!-- 채팅 입력창 -->
                <!-- <form enctype="multipart/form-data" id="fileForm"> -->
                <div class="chat_input_section">
                    <div class=chat_input_box>
                    	<!-- <input type=file name=file> -->
                        <button id=send_btn>전송</button>
                        <div id=input contenteditable=true>  <!-- 입력창 -->
                        	
                        	<pre class=pre><code class="code_editor hljs" style="overflow-x: hidden"></code></pre>  <!-- 코드 편집기 -->
                        	
                        </div>
                        
                        <div class=icon_box>
                            <img src=resources/images/chatting/smile.png class="input_icon emoticon_icon">
                            <img src=resources/images/chatting/file.png class="input_icon file_icon">
                            <img src=resources/images/chatting/code.png class="input_icon code_icon" style="width: 22px; margin-top: 4px">
                        </div>
                    </div>
                    
                    <!-- 이모티콘 섹션 -->
                    <div class=emoticon_section>
                        <div class=emoticon_title>
                        	이모티콘
                        </div>
                        <div class=emoticon_box>
                        	<c:forEach var="i" begin="1" step="1" end="20">
                        		<img src="resources/images/chatting/1-${i}.gif" class=emoticon id="1-${i}.gif">
                        	</c:forEach>
                            
                        </div>
                    </div>
                    
                </div>
				<!-- </form> -->
			
			
			<!-- 여기까지 각자 영역 설정 -->
		</div>
	</section>
</body>
</html>