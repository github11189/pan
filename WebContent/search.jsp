<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="org.elasticsearch.search.SearchHit,beans.EsDao,java.util.Map.Entry,java.util.Map,java.util.Set"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>根据条件搜索</title>
</head>
<body>
	<form action="result.jsp" method="post">
		搜索条件：<input type="text" name="params"><br> 
				<input type="submit" value="搜索">
	</form>
</body>
</html>