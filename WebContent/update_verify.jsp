<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*"%>
<%@ include file="sqlLoginInfo.jsp" %>

<%
	String userNum = (String) session.getAttribute("user");
	String userEmail = new String(request.getParameter("userEmail"));
	String originalPWD = new String(request.getParameter("originalPWD"));
	String newPWD = new String(request.getParameter("newPWD"));
	String checkPWD = new String(request.getParameter("checkPWD"));
	int checkupdate = 0;
	
	// email만 수정할 경우에는 비밀번호가 필요 없다.
	if(originalPWD.equals("") && newPWD.equals("") && checkPWD.equals("")){
		if(userEmail.equals("")){
			// 어떤 정보도 수정하지 않을 경우 %>
			<script>
			alert("수정할 정보를 입력해주세요.");
			location.href = "update.jsp";
			</script>
	<%	}
		else {
			// 이메일 주소만 수정하는 경우
			boolean emailform = false;
			String regex = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$"; 
			Pattern p = Pattern.compile(regex); 
			Matcher m = p.matcher(userEmail); 
			if(m.matches()) { emailform = true; }
			if(!emailform){ %>
				<script>
				alert("이메일 형식이 맞지 않습니다!");
				location.href = "update.jsp";
				</script>	
		<%	}

			try{
				Class.forName(driver);
				conn = DriverManager.getConnection(url, user, password);
				stmt = conn.createStatement();
				sql = "UPDATE student SET s_email='" + userEmail + "' WHERE s_num='" + userNum + "'";
				checkupdate = stmt.executeUpdate(sql);
				if(checkupdate > 0){%>
					<script>
						alert("학생 정보가 수정되었습니다.");
						location.href="update.jsp";
					</script>
			<%	}
				else{ %>
					<script>
						alert("잠시 후 다시 시도해주세요.");
						location.href="update.jsp";
					</script>
			<%	}
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				if(rs != null) rs.close();
				if(conn != null) conn.close();
				if(stmt != null) stmt.close();
			}
		}
	}
	else {
		// 비밀번호를 수정하는 경우
	
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
				alert("비밀번호 수정 시 기존 비밀번호가 맞아야합니다.");
				location.href="update.jsp";
				</script>
		<%	}
		
			if(userEmail.equals("")) sql = "UPDATE student SET s_pwd='" + newPWD + "' WHERE s_num='" + userNum + "'";
			else sql = "UPDATE student SET s_pwd='" + newPWD + "', s_email='" + userEmail + "' WHERE s_num='" + userNum + "'";
			checkupdate = stmt.executeUpdate(sql);
			if(checkupdate > 0){%>
				<script>
					alert("학생 정보가 수정되었습니다.");
					location.href="update.jsp";
				</script>
		<%	}
			else{ %>
				<script>
					alert("잠시 후 다시 시도해주세요.");
					location.href="update.jsp";
				</script>
		<%	}
		} catch(SQLException ex){
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
	}
	%>
	