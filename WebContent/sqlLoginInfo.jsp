<%@ page import = "java.sql.*" %>
<%
String driver = "oracle.jdbc.driver.OracleDriver";
String url = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "db1710904";
String password = "oracle";
	
Connection conn = null;
Statement stmt = null;
String sql = null;
ResultSet rs = null;
%>