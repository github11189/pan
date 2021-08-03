<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="org.elasticsearch.search.SearchHit,beans.EsDao,java.util.Map.Entry,java.util.Map,java.util.Set"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%
String params=request.getParameter("params");
if(params==null){params="--";}
	EsDao es = new EsDao();
// 	if(params != null){
		SearchHit[] hits2 = es.search(params);
// 		response.sendRedirect("search.jsp");
// 	}
// }

%>
</head>
<body>
	<form action="" method="post">
		搜索条件：<input type="text" name="params"><br> 
				<input type="submit" value="搜索">
	</form>
	
	<h2>搜索结果：</h2>
	<br>
	<table style="width: 1000px; margin-left: 100px;" border="1">
		<tr>
			<td>类型</td>
			<td>名称</td>
			<td>大小(KB)</td>
			<td>操作</td>
			<td>操作</td>
		</tr>
		<%
			if (hits2 != null)
			for (SearchHit searchHit : hits2) {
				Map<String, Object> sourceAsMap = searchHit.getSourceAsMap();
				System.out.println(sourceAsMap);
				for (Entry<String, Object> entry : sourceAsMap.entrySet()) {
		%>
		<%
			System.out.println(entry.getKey() + "\t" + entry.getValue());
		}
		// 					Map<String, HighlightField> highlightFields = searchHit.getHighlightFields();
		// 					for (Map.Entry<String, HighlightField> ee : highlightFields.entrySet()) {
		// 						System.out.println(ee.getKey());
		// 						System.out.println(ee.getValue());
		// 					}
		}
		%>
		<!-- 		<tr> -->
		<!-- 			<td><img alt="图标" -->
		<!-- 				src="images/file.png"%>" /></td> -->
		<!-- 			<td> -->
		<%-- 				<% --%>
		// if (list[i].isDirectory() == true) {
		<%-- 				%> <a href="brows.jsp?url=<%=list[i].getPath().toString()%>"><%=list[i].getPath().getName()%></a> --%>
		<%-- 				<% --%>
		// } else {
		<%-- 				%> <%=list[i].getPath().getName()%> <% --%>
		// }
		<%--  %> --%>
		<!-- 			</td> -->
		<%-- 			<td><%=list[i].isDirectory() ? "" : list[i].getLen() / 1024%></td> --%>
		<%-- 			<% --%>
		// if (list[i].isFile()) {
		<%-- 			%> --%>
		<!-- 			<td><a style="color: green" -->
		<%-- 				href="download.jsp?filePath=<%=java.net.URLEncoder.encode(list[i].getPath().toString(), "GB2312")%>">下载</a> --%>
		<!-- 			</td> -->
		<%-- 			<% --%>
		// }
		<%-- 			%> --%>
		<!-- 			<td><a style="color: red" -->
		<%-- 				href="delete.jsp?filePath=<%=java.net.URLEncoder.encode(list[i].getPath().toString(), "GB2312")%>">删除</a> --%>
		<!-- 			</td> -->
		<!-- 		</tr> -->
		<%-- 		<% --%>
		// }
		<%-- 		%> --%>
	</table>

</body>
</html>