<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.io.InputStream,beans.HdfsDao"%>
<%
	String filepath = new String(request.getParameter("filePath").getBytes("ISO-8859-1"), "GB2312");
if (filepath != null) {
	HdfsDao dao = new HdfsDao();
	dao.delete(filepath);
	response.sendRedirect("brows.jsp");
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>My JSP 'delete.jsp' starting page</title>
</head>

<body>
	This is my JSP page.
	<br>
</body>
</html>
