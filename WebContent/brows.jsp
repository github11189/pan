<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="org.apache.hadoop.fs.FileStatus,beans.HdfsDao"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>云盘系统</title>
<%
	HdfsDao dao = new HdfsDao();
FileStatus[] list = null;
//缓存当前路径
String currenturl = "";
if (request.getParameter("url") != null) {
	//当页面被刷新
	currenturl = request.getParameter("url");
	list = dao.Brower(currenturl);
} else {
	//当页面第一次初始加载 
	currenturl = "hdfs://192.168.112.90:9000";
	list = dao.Brower();
}
%>
</head>
<body>
	<h1 align="center">云盘与搜索系统</h1>
	<h3>当前目录：<%=currenturl%></h3>
	<div align="left">
		<a href="createdir.jsp?url=<%=currenturl%>">创建目录</a>
	</div>
	<div align="center">
		<a href="search.jsp?">搜索入口</a>
	</div>
	<div align="right">
		<a href="upload.jsp?url=<%=currenturl%>">上传文件</a>
	</div>
	<table style="width: 1000px; margin-left: 100px;" border="1">
		<tr>
			<td align="center">类型</td>
			<td align="center">名称</td>
			<td align="center">大小(KB)</td>
			<td align="center">删除操作</td>
			<td align="center">下载操作</td>
		</tr>
		<%
			if (list != null)
			for (int i = 0; i < list.length; i++) {
		%>
		<tr>
			<td><img alt="图标"
				src="images/<%=list[i].isDirectory() ? "dir.png" : "file.png"%>" /></td>
			<%-- 			 <%=list[i].isDirectory()?"dir.png":"file.png" %> --%>
			<td>
				<%
					if (list[i].isDirectory() == true) {
				%> <a href="brows.jsp?url=<%=list[i].getPath().toString()%>"><%=list[i].getPath().getName()%></a>
				<%
					} else {
				%> <%=list[i].getPath().getName()%> <%
 	}
 %>
			</td>
			<td><%=list[i].isDirectory() ? "" : list[i].getLen() / 1024%></td>
			<td><a style="color: red"
				href="delete.jsp?filePath=<%=java.net.URLEncoder.encode(list[i].getPath().toString(), "GB2312")%>">删除</a>
			</td>
			<%
				if (list[i].isFile()) {
			%>
			<td><a style="color: green"
				href="download.jsp?filePath=<%=java.net.URLEncoder.encode(list[i].getPath().toString(), "GB2312")%>">下载</a>
			</td>
			<%
				}
			%>
		</tr>
		<%
			}
		%>
	</table>

</body>
</html>