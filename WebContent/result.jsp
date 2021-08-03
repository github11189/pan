<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="org.elasticsearch.search.SearchHit,beans.EsDao,java.util.Map.Entry,java.util.Map,java.util.Set,org.elasticsearch.search.fetch.subphase.highlight.HighlightField,org.elasticsearch.common.text.Text"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%
	request.setCharacterEncoding("utf-8");
	String params = request.getParameter("params");
	EsDao es = new EsDao();
	SearchHit[] hits2 = es.search(params);
// 		response.sendRedirect("search.jsp");
%>
</head>
<body>
	<h2>搜索结果：</h2>
	<table style="width: 1000px; margin-left: 100px;" border="2">
		<tr>
			<td align="center">类型</td>
			<td align="center">名称</td>
			<td align="center">来源</td>
			<td align="center">大小(KB)</td>
			<td align="center">内容</td>
			<td align="center">匹配情况高亮显示</td>
			<td align="center">相关度</td>
		</tr>
		<%
			if (hits2 != null)
			for (SearchHit searchHit : hits2) {
				Map<String, Object> sourceAsMap = searchHit.getSourceAsMap();
		%>

		<tr>
			<td><img alt="图标" src="images/<%="file.png"%>" /></td>
			<td><%=sourceAsMap.get("name")%></td>
			<td><%=sourceAsMap.get("path")%></td>
			<td><%=sourceAsMap.get("size")%></td>
			<td><%=sourceAsMap.get("content")%></td>

			<%
				Map<String, HighlightField> highlightFields = searchHit.getHighlightFields();
			HighlightField highlight = highlightFields.get("content");
			Text[] fragments = highlight.fragments();
			String fragmentString = fragments[0].string();
			%>
			<td><%=fragmentString%></td>
			<td><%=searchHit.getScore()%></td>
			<%
				}
			%>
		    
		<tr>
	</table>

</body>
</html>