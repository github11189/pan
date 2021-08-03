<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="org.apache.hadoop.fs.FileStatus,beans.HdfsDao"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%
  HdfsDao dao=new HdfsDao();
  FileStatus[] list=null;
  String currenturl=""; //记录当前路径
  if(request.getParameter("currenturl")!=null){
	  currenturl=request.getParameter("currenturl").toString();
  }
  
  if(request.getParameter("url")!=null){
		//当页面被刷新
	  String url=request.getParameter("url").toString();
	  currenturl=currenturl+"/"+request.getParameter("url").toString();
	  list=dao.Brower(currenturl);
  }
  else{
		//当页面第一次初始加载
	  list=dao.Brower();
	}
%>
</head>
<body>
	<h1>桂电WEB</h1>
	<table width=258 border="1">
	<tr>
		<td>类型</td><td>名称</td><td>大小</td><td>操作</td>
	</tr>
		<% for (int i = 0; i < list.length; i++) { %>
		<tr>
			<td>
			 <img alt="图标" src="images/<%=list[i].isDirectory()?"dir.png":"file.png" %>"/></td>
<%-- 			 <%=list[i].isDirectory()?"dir.png":"file.png" %> --%>
			<br>
			<td>
				<%if (list[i].isDirectory()==true) {%> <a href="index1.jsp?url=<%=list[i].getPath().getName() %>&currenturl=<%=currenturl %>"><%=list[i].getPath().getName() %></a>
				<%}else {%> <%=list[i].getPath().getName() %> <% }%>
			</td>
			<br>
			<td><%=list[i].isDirectory()?"":list[i].getLen()/1024 %></td>
			<br>
			<td><a href="">下载</a><a href="">删除</a></td>

		</tr>
		<%} %>
		</table>
</body>
</html>