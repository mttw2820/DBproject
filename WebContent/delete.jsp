<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"  %>
<%@ include file = "sqlLoginInfo.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>수강신청 삭제</title>
</head>

<body>
<%@ include file="top.jsp" %>
<%   
	String userNum = session_id;
	if(userNum == null){ %>
		<script>
		alert("로그인 후 사용 가능한 서비스입니다.");
		location.href = "login.jsp";
		</script>
<%	} %>

<table width="75%" align="center" border>
	<br>
	<tr><th>과목번호</th><th>분반</th><th>과목명</th><th>학점</th><th>수강취소</th></tr>
	<%  
		try {
			Class.forName(driver);
	        conn =  DriverManager.getConnection (url, user, password);
			
			// 조건 1. 학생이 신청한 강의
			// 조건 2. 올해, 이번학기의 강의
			String dateConSql = "en_year = Date2EnrollYear(SYSDATE) AND en_semester = Date2EnrollSemester(SYSDATE)";
			String subsql = "SELECT en_cNum, en_cDiv FROM enroll WHERE en_sNum = ? AND " + dateConSql;
			sql = "SELECT c_num, c_div, c_title, c_grade FROM class WHERE (c_num, c_div) IN (" + subsql + ") order by c_num, c_div";
	
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userNum);
			rs = pstmt.executeQuery();

			if (rs != null) {
				while (rs.next()) {	
					String c_num = rs.getString("c_num");
					int c_div = rs.getInt("c_div");			
					String c_title = rs.getString("c_title");
					int c_grade = rs.getInt("c_grade");			%>					
					<tr>
	  				<td align="center"><%= c_num %></td>
	  				<td align="center"><%= c_div %></td> 
	  				<td align="center"><%= c_title %></td>
	  				<td align="center"><%= c_grade %></td>
	  				<td align="center"><a href="delete_verify.jsp?c_num=<%= c_num %>&c_div=<%= c_div %>">취소</a></td>
					</tr>
			<%	}
			}

		} catch(SQLException ex){
			System.err.println("SQLException: " + ex.getMessage());
		} catch(Exception e){
			e.printStackTrace();
		} finally{
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		}
		%>
</table>

</body>
</html>