<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="org.apache.hadoop.fs.FileStatus,beans.HdfsDao"%>
<%
String url=request.getParameter("url");
request.setCharacterEncoding("utf-8");
String dirname=request.getParameter("dirname");
if(dirname!=null){
	HdfsDao dao=new HdfsDao();
	if(dirname.length()>0){
		dao.createdir(url+"/"+dirname);
		response.sendRedirect("brows.jsp");
	}
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>创建新目录</title>
</head>

<body>
	<form action="" method="post">
		目录名称:<input type="text" name="dirname"><input type="submit"
			value="创建目录">
	</form>
</body>
</html>
