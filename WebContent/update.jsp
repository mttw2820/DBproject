<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>

<head>
<meta charset="EUC-KR">
<title>수강신청 사용자 정보 수정</title>
</head>

<body>
<%@ include file = "top.jsp" %>
<%@ include file = "sqlLoginInfo.jsp" %>
<%
	// check login status
	boolean checkPWD = false;
	String userNum = session_id;
	String userPWD = "";
	String userName = "";
	String userEmail = null;
	String emailplaceholder = null;
	if(userNum == null){ %>
		<script>
		alert("로그인 후 사용 가능한 서비스입니다."); 
		location.href = "login.jsp"
		</script>
<%	}
		
		
	// get user info from student table
	try{
		Class.forName(driver);
		conn = DriverManager.getConnection(url, user, password);
		stmt = conn.createStatement();
		
		// 아이디 패스워드 확인
		sql = "SELECT * FROM student WHERE s_num = '" + userNum + "'";
		rs = stmt.executeQuery(sql);
		if(rs.next()){
			userPWD = rs.getString(2);
			userName = rs.getString(3);
			userEmail = rs.getString(4);
			if(rs.wasNull()){	// 나머지는 not null - null이라면 email이 없는 것
				emailplaceholder = "email@domain.com";
			}	
		}
	} catch(SQLException e){
		System.err.println("SQLException: " + e.getMessage());
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if(rs != null) rs.close();
		if(stmt != null) stmt.close();
		if(conn != null) conn.close();
	} %>


<table width="75%" align="center" border>
	<tr bgcolor = "#CAD4F7">
		<td><div align="center">수강신청 사용자 정보 수정</div></td>
	</tr>
	
	<form method="post" action="update_verify.jsp">
	<tr>
		<td><div align="center">학번</div></td>
		<td><div align="center"><%= userNum %> </div></td>
		</tr>
	<tr>
		<td><div align="center">이름</div></td>
		<td><div align="center"><%= userName %> </div></td>
	</tr>
	<tr>
		<td><div align="center">이메일</div></td>
		<td>
			<div align="center"> 
				<input type="text" name="userEmail" 
					<% if(userEmail != null){ %> 
							value = "<%=userEmail%>"
					<%  } else { %>
							placeholder = "<%=emailplaceholder %>"
					<%	} %> >
			</div>
		</td>
	</tr>
	<tr>
		<td><div align="center">비밀번호 확인</div></td>
		<td>
			<div align="center"> 
				<input type="text" name="originalPWD" placeholder = "original password">
			</div>
		</td>
	</tr>
	<tr>
		<td><div align="center">비밀번호 수정</div></td>
		<td>
			<div align="center">
				<input type="text" name="newPWD" placeholder="new password">
			</div>
		</td>
	</tr>
	<tr>
		<td><div align="center">수정된 비밀번호 확인</div></td>
		<td>
			<div align="center"> 
				<input type="text" name="checkPWD" placeholder="check new password">
			</div>
		</td>
	</tr>
	<tr>
		<td colspan=2>
			<div align="center">
				<input type="submit" name="Submit" value="수정">
				<input type="reset" value="취소">
			</div>
		</td>
	</tr>
	</form>
</table>
</body>
</html>