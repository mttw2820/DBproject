<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"  %>
<%@ include file = "sqlLoginInfo.jsp" %>
<html><head><title>수강신청 입력</title></head>
<body>
<%@ include file="top.jsp" %>
<%   if (session_id==null) response.sendRedirect("login.jsp");  %>

<table width="75%" align="center" border>
	<br>
	<tr><th>과목번호</th><th>분반</th><th>과목명</th><th>학점</th><th>수강신청</th></tr>
	<%  
		try {
			Class.forName(driver);
	        conn =  DriverManager.getConnection (url, user, password);
			stmt = conn.createStatement();	
    	} catch(SQLException ex) {
	    	System.err.println("SQLException: " + ex.getMessage());
   	 	}
		try{
			sql = "select c_num,c_div,c_title,c_grade from class where c_num not in (select en_cNum from enroll where en_sNum='" + session_id + "') order by c_num, c_div";
	
			rs = stmt.executeQuery(sql);

			if (rs != null) {
				while (rs.next()) {	
					String c_num = rs.getString("c_num");
					int c_div = rs.getInt("c_div");			
					String c_title = rs.getString("c_title");
					int c_grade = rs.getInt("c_grade");			%>
					<tr>
	  				<td align="center"><%= c_num %></td> <td align="center"><%= c_div %></td> 
	  				<td align="center"><%= c_title %></td><td align="center"><%= c_grade %></td>
	  				<td align="center"><a href="insert_verify.jsp?c_num=<%= c_num %>&c_div=<%= c_div %>">신청</a></td>
					</tr>
			<%	}
			}

		} catch(SQLException ex){
			System.err.println("SQLException: " + ex.getMessage());
		} catch(Exception e){
			e.printStackTrace();
		} finally{
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
		%>
</table>
</body>
</html>
    