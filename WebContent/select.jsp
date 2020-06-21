<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"  %>
<html><head><title>수강신청 입력</title></head>
<body>
<%@ include file="top.jsp" %>
<%@ include file = "sqlLoginInfo.jsp" %>
<%   if (session_id==null) response.sendRedirect("login.jsp");  %>

<table width="75%" align="center" border>
<br>
<tr><th>과목번호</th><th>분반</th><th>과목명</th><th>강의시간</th><th>인정학점</th></tr>
<%
	
	String userNum = "";
	if((userNum = session_id) == null){ %>
		<script>
		alert("로그인 후 이용 가능한 서비스입니다.");
		location.href("login.jsp");
		</script>
	<% }
	

	String class_num ="";
	int class_div = 0;
	String class_name = "";
	int class_grade = 0;
	String int_class_day = "";
	String str_class_day = "";
	String class_start = "";
	String class_end = "";
	int total_credit = 0;
	

	try {
		Class.forName(driver);          
		conn =  DriverManager.getConnection(url, user, password);
		stmt = conn.createStatement();		
		String dateConSql = "en_year = Date2EnrollYear(SYSDATE) AND en_semester = Date2EnrollSemester(SYSDATE)";
		String subsql = "SELECT en_cNum FROM enroll WHERE " + dateConSql;
		sql = "SELECT cid, cdiv, ctitle, cday, ctime_h, ctime_m, credit FROM enroll_info WHERE sid ='" + session_id + "' AND cid IN (" + subsql + ") order by cid, cdiv";
		rs = stmt.executeQuery(sql);
		while (rs.next()) {
			class_num = rs.getString("cid");
			class_div = rs.getInt("cdiv");
			class_name = rs.getString("ctitle");
			class_grade = rs.getInt("credit");
			total_credit = total_credit + class_grade;
			int_class_day = "" + rs.getInt("cday");
			String start = null;
			String end = null;
			int st = rs.getInt("ctime_h");
			start = st + "";
			if (st == 0)  
				start = "00";
			int et = rs.getInt("ctime_m");
			end = et + "";
			if (et == 0)  
				end = "00";
			class_start = "" + rs.getInt("ctime_h");
			class_start = class_start + " : " + start;
			class_end = "" + rs.getInt("ctime_m");
			class_end = class_end + " : " + end;
			
			sql = "{? = call day_map(?)}";
			cstmt = conn.prepareCall(sql);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, int_class_day);
			cstmt.execute();
			str_class_day = cstmt.getString(1);
			
	%>
		<tr>
			<td align="center"><%=class_num %></td> 
			<td align="center"><%=class_div %></td> 
			<td align="center"><%=class_name %></td> 
			<td align="center"><%=str_class_day %> <%=class_start %> - <%=class_end %></td>
			<td align="center"><%=class_grade %></td> 
		</tr>
	<%
		}	
		rs.close();
		stmt.close();
		conn.close();
	} 
	catch(SQLException ex) { 
		System.err.println("SQLException: " + ex.getMessage());
	}
	%>
	</tr>
	</table>
	<br/>
	<br/>
	<table width="50%" align="center" border>
		<td align="center"><%="총 수강 신청 학점"%></th><td align="center"><%=total_credit %></td>
	</div>
	<%
%>
</table>
</body>
</html>
