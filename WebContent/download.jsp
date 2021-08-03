<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.io.InputStream,beans.HdfsDao,java.io.OutputStream"%>
<%
	String filepath = new String(request.getParameter("filePath").getBytes("ISO-8859-1"), "GB2312");
HdfsDao dao = new HdfsDao();
InputStream in = null;
OutputStream outp = null;
if (filepath != null) {
	in = dao.getFileInputStreamForPath(filepath);
	outp = response.getOutputStream();
	String fname = filepath.substring(filepath.lastIndexOf("/"));
	response.setContentType("text/html");
	response.reset();
	response.setContentType("application/x-download");
	response.addHeader("Content-Disposition", "attachment;filename=" + fname);
	byte[] bs = new byte[1024];
	int length = in.read(bs);
	while (length != -1) {
		outp.write(bs, 0, length);
		outp.flush();
		length = in.read(bs);
	}
	outp.close();
	in.close();
}
%>

