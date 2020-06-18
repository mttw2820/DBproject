<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="sqlLoginInfo.jsp" %>

<%
	String userID = request.getParameter("userID");
	String userPassword = request.getParameter("userPassword");
	boolean isLogin = false;
	
	try{
		Class.forName(driver);
		conn = DriverManager.getConnection(url, user, password);
		stmt = conn.createStatement();
		
		// 아이디 패스워드 확인
		sql = "SELECT * FROM student WHERE s_num='"+userID+"' AND s_pwd='" + userPassword + "'";
		rs = stmt.executeQuery(sql);
		
		if(rs.next()) {
			isLogin = true;
		}
		
	} catch(ClassNotFoundException e){
		System.out.println("jdbc driver 로딩 실패");
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if(rs != null) rs.close();
		if(stmt != null) stmt.close();
		if(conn != null) conn.close();
	}
	
	
	if(isLogin){ // correct -> login 후 main으로 
		session.setAttribute("user", userID); %>
		<script>
		alert("로그인 되었습니다.");
		location.href="main.jsp";
		</script>
<%	} else { // incorrect -> login으로 %>
		<script>
		alert("아이디 또는 패스워드가 올바르지 않습니다.");
		location.href="login.jsp";
		</script>	
<%	}
	
	
%>