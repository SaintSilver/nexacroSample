<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page language="java"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.nexacro17.xapi.data.*" %>
<%@ page import="com.nexacro17.xapi.tx.*" %>

<%
	String sHeader = request.getHeader("Content-Type");
	if (sHeader == null)
	{
		return;
	}
	request.setCharacterEncoding("utf-8");
	//String sRealPath = request.getSession().getServletContext().getRealPath("/");
	String sRealPath = request.getSession().getServletContext().getRealPath("/nexacro17/");
	String sPath     = request.getParameter("PATH");
	String sUpPath   = sRealPath + sPath;
	int    nMaxSize  = 500 * 1024 * 1024; // 최대 업로드 파일 크기 500MB(메가)로 제한

	System.out.println(sUpPath);
	
	PlatformData resData    = new PlatformData();
	VariableList resVarList = resData.getVariableList();
	
	String sMsg = " A ";
	try 
	{
		MultipartRequest multi = new MultipartRequest(request, sUpPath, nMaxSize, "utf-8", new DefaultFileRenamePolicy());
		Enumeration files      = multi.getFileNames();
		
		sMsg += "B ";
		DataSet ds = new DataSet("Dataset00");		
		ds.addColumn(new ColumnHeader("FILENAME", DataTypes.STRING));
		ds.addColumn(new ColumnHeader("FILETYPE", DataTypes.STRING));
		ds.addColumn(new ColumnHeader("FILESIZE", DataTypes.LONG));
		
		sMsg += "C ";
		String sFName = "";
		String sName  = "";
		String stype  = "";
		File   f      = null;
		
		while (files.hasMoreElements()) 
		{
			sMsg += "D ";
			sName  = (String)files.nextElement();
			sFName = multi.getFilesystemName(sName);
			stype  = multi.getContentType(sName);
			int nRow = ds.newRow();
			ds.set(nRow, "FILENAME", sFName);
			ds.set(nRow, "FILETYPE", stype);

			f = multi.getFile(sName);			
			if (f != null)
			{
				ds.set(nRow, "FILESIZE", f.length());
			}		
			sMsg += nRow +" ";
		}
		
		resData.addDataSet(ds);
		resVarList.add("ErrorCode", 200);
		resVarList.add("ErrorMsg", sUpPath+"/"+sFName);
	} 
	catch (Exception e) 
	{
		resVarList.add("ErrorCode", 500);
		resVarList.add("ErrorMsg", sMsg + " " + e);
	}

	HttpPlatformResponse res = new HttpPlatformResponse(response);
	res.setData(resData);
	res.sendData();
%>
