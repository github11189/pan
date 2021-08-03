<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.io.File,beans.HdfsDao,beans.EsDao"%>
<%@ page
	import="org.apache.commons.fileupload.servlet.ServletFileUpload,org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%
	String url = request.getParameter("url");
request.setCharacterEncoding("utf-8");
int maxFileSize = 50 * 1024 * 1024; //50M
int maxMemSize = 50 * 1024 * 1024; //50M
ServletContext context = getServletContext();
String filePath = "d:\\";
File file;
String contentType = request.getContentType();
if (contentType != null) {
	if (contentType.indexOf("multipart/form-data") >= 0) {
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// 设置内存中存储文件的最大值
		factory.setSizeThreshold(maxMemSize);
		// 本地存储的数据大于 maxMemSize.
		factory.setRepository(new File("c:\\temp"));
		// 创建一个新的文件上传处理程序
		ServletFileUpload upload = new ServletFileUpload(factory);
		// 设置最大上传的文件大小
		upload.setSizeMax(maxFileSize);
		try {
	// 解析获取的文件
	List fileItems = upload.parseRequest(request);
	// 处理上传的文件
	Iterator i = fileItems.iterator();
	//System.out.println("begin to upload file to tomcat server</p>"); 
	while (i.hasNext()) {
		FileItem fi = (FileItem) i.next();
		if (!fi.isFormField()) {
			// 获取上传文件的参数
			//返回表单标签name属性的值
			String fieldName = fi.getFieldName();
			System.out.println(fieldName + "11111111111111");
			//返回文件名
			String fileName = fi.getName();
			String fn = fileName.substring(fileName.lastIndexOf("\\") + 1);
			boolean isInMemory = fi.isInMemory();
			long sizeInBytes = fi.getSize();
			// 写入文件
			if (fileName.lastIndexOf("\\") >= 0) {
				file = new File(filePath, fileName.substring(fileName.lastIndexOf("\\")));
			} else {
				file = new File(filePath, fileName.substring(fileName.lastIndexOf("\\") + 1));
			}
			fi.write(file);

			//"begin to upload file to hadoop hdfs; 
			String local = filePath + "\\" + fileName;
			//将tomcat上的文件上传到hadoop上
			HdfsDao hdfs = new HdfsDao();
			String hdfsPath = url + "/";
			hdfs.copyFile(local, hdfsPath);
			//同时，将要上传的数据写入到ES一份
			EsDao es=new EsDao();
			es.writeEs(local);
			response.sendRedirect("brows.jsp");
		}
	}
		} catch (Exception ex) {
	System.out.println(ex);
		}

	}
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<title>My JSP 'index.jsp' starting page</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
</head>

<body>
	<form class="form-inline" method="POST" enctype="MULTIPART/FORM-DATA"
		action="">
		<div style="line-height: 50px; float: left;">
			<input type="submit" name="submit" value="上传文件">
		</div>
		<div style="line-height: 50px; float: left;">
			<input type="file" name="file" size="30" />
		</div>
	</form>
</body>
</html>
