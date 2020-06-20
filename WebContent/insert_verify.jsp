<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="sqlLoginInfo.jsp" %>
<html><head><title> 수강신청 입력 </title></head>
<body>

<%	
	String s_num = (String)session.getAttribute("user");
	String c_num = request.getParameter("c_num");
	int c_div = Integer.parseInt(request.getParameter("c_div"));
	String result = null;
%>
<%		 
	
	try {
		Class.forName(driver);
  	    conn =  DriverManager.getConnection (url, user, password);
    } catch(SQLException ex) {
	     System.err.println("SQLException: " + ex.getMessage());
    }
    cstmt = conn.prepareCall("{call insertEnroll(?,?,?,?)}");	
	cstmt.setString(1, s_num);
	cstmt.setString(2, c_num);
	cstmt.setInt(3, c_div);
	cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);	
	try  {  	
		cstmt.execute();
		result = cstmt.getString(4);		
%>
<script>	
	alert("<%= result %>"); 
	location.href="insert.jsp";
</script>
<%		
	} catch(SQLException ex) {		
		 System.err.println("SQLException: " + ex.getMessage());
	}  
	finally {
	    if (cstmt != null) 
            try { conn.commit(); cstmt.close();  conn.close(); }
 	      catch(SQLException ex) { }
     }
%>
</form></body></html>
    