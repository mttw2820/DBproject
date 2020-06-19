<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="sqlLoginInfo.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title> 수강취소 입력 </title>
</head>
<body>
<%

String userNum = (String) session.getAttribute("user");
String c_num = request.getParameter("c_num");
int c_div = Integer.parseInt(request.getParameter("c_div"));

try{
	Class.forName(driver);
	conn = DriverManager.getConnection(url, user, password);
	
	// delete enroll
	String dateConSql = "en_year = Date2EnrollYear(SYSDATE) AND en_semester = Date2EnrollSemester(SYSDATE)";
	String classConSql = "en_sNum = ? AND en_cNum = ? AND en_cDiv = ?";
	sql = "DELETE FROM enroll WHERE " + classConSql + " AND " + dateConSql ;
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, userNum);
	pstmt.setString(2, c_num);
	pstmt.setInt(3, c_div);
	int result = pstmt.executeUpdate();
	if(result < 0){ %>
		<script> 
		alert("잠시 후 다시 시도해주세요.");
		location.href = "delete.jsp";
		</script>
<%	}
	else{ %>
		<script>
		alert("수강 신청이 취소되었습니다.");
		location.href = "delete.jsp";
		</script>	
<%	}
	
} catch(SQLException ex){
	System.err.println("SQLException: " + ex.getMessage());
} catch(Exception e){
	e.printStackTrace();
} finally{
	if(rs != null) rs.close();
	if(pstmt != null) pstmt.close();
	if(stmt != null) stmt.close();
	if(conn != null) conn.close();
}


%>

</body>
</html>