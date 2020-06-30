<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<link rel="stylesheet" href="../../resources/css/member/login.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


<script>
	$(document).ready(function() {
		var userInputId = getCookie("userInputId");//저장된 쿠기값 가져오기
		$("input[name='email']").val(userInputId);

		if ($("input[name='email']").val() != "") { // 그 전에 ID를 저장해서 처음 페이지 로딩
			// 아이디 저장하기 체크되어있을 시,
			$("#idSaveCheck").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
		}

		$("#idSaveCheck").change(function() { // 체크박스에 변화가 발생시
			if ($("#idSaveCheck").is(":checked")) { // ID 저장하기 체크했을 때,
				var userInputId = $("input[name='email']").val();
				setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
			} else { // ID 저장하기 체크 해제 시,
				deleteCookie("userInputId");
			}
		});

		// ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
		$("input[name='email']").keyup(function() { // ID 입력 칸에 ID를 입력할 때,
			if ($("#idSaveCheck").is(":checked")) { // ID 저장하기를 체크한 상태라면,
				var userInputId = $("input[name='email']").val();
				setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
			}
		});
	});

	function setCookie(cookieName, value, exdays) {
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var cookieValue = escape(value)
				+ ((exdays == null) ? "" : "; expires=" + exdate.toGMTString());
		document.cookie = cookieName + "=" + cookieValue;
	}

	function deleteCookie(cookieName) {
		var expireDate = new Date();
		expireDate.setDate(expireDate.getDate() - 1);
		document.cookie = cookieName + "= " + "; expires="
				+ expireDate.toGMTString();
	}

	function getCookie(cookieName) {
		cookieName = cookieName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cookieName);
		var cookieValue = '';
		if (start != -1) {
			start += cookieName.length;
			var end = cookieData.indexOf(';', start);
			if (end == -1)
				end = cookieData.length;
			cookieValue = cookieData.substring(start, end);
		}
		return unescape(cookieValue);
	}

	window.onload = function() {
		document.getElementById("login_form").onsubmit = function() {
			var email = document.getElementById("email").value;

			var pw = document.getElementById("pw").value;

			if (email == "" || pw == "") {
				alert("로그인 필수 입력칸이 공백 입니다.")
				return false
			} else {
				return true
			}
		}

		document.getElementById("auth_form").onsubmit = function() {
			var e_mail = document.getElementById("e_mail").value;

			if (e_mail == "") {
				alert("가입을 위해서는 이메일 주소를 입력해야 합니다.")
				return false
			} else {
				return true
			}
		}

	}
</script>



</head>
<body>



	<div class="container" id="container">
		<div class="form-container log-in-container">
			<form id="login_form" action="login">
				<h1>로그인</h1>
				<br> <br> <input type="email" name="email" id="email"
					placeholder="Email" class="in" /> <input type="password" name="pw"
					id="pw" placeholder="Password" class="in" /> <br> <br>
				<div class="id">
					<input type="checkbox" class="checkbox" id="idSaveCheck"> <span>
						email 기억하기(미구현)</span>
				</div>
				<br>
				<button type="submit">LogIn</button>
			</form>
		</div>

		<div class="overlay-container">
			<div class="overlay">
				<div class="overlay-panel overlay-right">
					<form action=auth method="post" id="auth_form">
						<h1 style="color: black">가입하기</h1>
						<br>
						<br>
						<br>
						<br> <input type="email" name="e_mail" id="e_mail"
							placeholder="이메일주소를 입력하세요." class="in"> <br>
						<br>
						<br>
						<br>
						<br>
						<button type="submit" name="submit">SignUp</button>

					</form>
				</div>
			</div>
		</div>
	</div>


</body>
</html>