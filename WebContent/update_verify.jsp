<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="sqlLoginInfo.jsp" %>

<%
	String userNum = (String) session.getAttribute("user");
	String originalPWD = new String(request.getParameter("originalPWD"));
	String newPWD = new String(request.getParameter("newPWD"));
	String checkPWD = new String(request.getParameter("checkPWD"));
	
	// 새로운 PWD와 확인 PWD가 다른 경우
	if(!newPWD.equals(checkPWD)){ %>
		<script>
		alert("새로운 비밀번호를 확인해주세요.");
		location.href="update.jsp";
		</script>
<% 	}
	
	
	try{
		Class.forName(driver);
		conn = DriverManager.getConnection(url, user, password);
		stmt = conn.createStatement();
		
		// 기존 비밀번호 확인
		boolean checkOriginalPWD = false;
		sql = "SELECT s_pwd FROM student WHERE s_num='" + userNum + "'";
		rs = stmt.executeQuery(sql);
		if(rs.next()){
			if(rs.getString(1).equals(originalPWD)){
				checkOriginalPWD = true;
			}
		}
		if(!checkOriginalPWD){	// 기존 비밀번호 오류 %>
			<script>
			alert("학생정보 수정 시 기존 비밀번호가 맞아야합니다.");
			location.href="update.jsp";
			</script>
	<%	}
		
		
		
		sql = "UPDATE student SET s_pwd='" + newPWD + "' WHERE s_num='" + userNum + "'";
		stmt.executeQuery(sql);
		%>
		<script>
			alert("학생 정보가 수정되었습니다.");
			location.href="update.jsp";
		</script>
<%	} catch(SQLException ex){
		String errMessage;
		if(ex.getErrorCode() == 20002)
			errMessage = "암호는 4자리 이상이어야 합니다.";
		else if(ex.getErrorCode() == 20003)
			errMessage = "암호에 공란은 입력되지 않습니다.";
		else {
			ex.printStackTrace();
			errMessage = "잠시 후 다시 시도해주세요.";
		}
		%>
		<script>
			alert("<%= errMessage %>");
			location.href="update.jsp";
		</script>
<%	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if(rs != null) rs.close();
		if(conn != null) conn.close();
		if(stmt != null) stmt.close();
	}
%>
	