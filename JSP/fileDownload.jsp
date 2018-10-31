<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page language="java"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.File"%>
<%

	String sRealPath = request.getSession().getServletContext().getRealPath("/nexacro17/");
	//String sRealPath = request.getSession().getServletContext().getRealPath("/");
	String sPath     = sRealPath + request.getParameter("PATH");
	String sName     = request.getParameter("file");
	String sFile     = new String(sName.getBytes("iso8859-1"), "UTF-8");
	byte[] buffer    = new byte[1024];

	System.out.println(sPath);

	ServletOutputStream out_stream = null;
	BufferedInputStream in_stream  = null;
	File fis = new File(sPath + "/" + sFile);

	if (fis.exists())
	{
		try
		{
			response.setContentType("utf-8");
			response.setContentType("application/octet;charset=utf-8");
			response.setHeader("Content-Disposition", "attachment;filename=" + sFile);
			out.clear();
			out = pageContext.pushBody();			
			out_stream = response.getOutputStream();
			in_stream  = new BufferedInputStream(new FileInputStream(fis));
			int nCnt = 0;
			while ((nCnt = in_stream.read(buffer, 0, 1024)) != -1) 
			{
				out_stream.write(buffer, 0, nCnt);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			if (in_stream != null) 
			{
				try 
				{
					in_stream.close();
				} 
				catch (Exception e)
				{
				}
			}
			if (out_stream != null) 
			{
				try 
				{
					out_stream.close();
				} 
				catch (Exception e) 
				{
				}
			}
		}
	}
	else
	{
			response.sendRedirect("unknownfile");
	}
%>
