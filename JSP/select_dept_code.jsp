<%@ page import="org.apache.commons.logging.*" %>
<%@ page import="com.nexacro17.xapi.data.*" %>
<%@ page import="com.nexacro17.xapi.tx.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page contentType="text/xml; charset=UTF-8" %>
<%@ include file="RsToDs.jsp" %>
<%
// PlatformData
PlatformData out_PlatformData = new PlatformData();
    
int    nErrorCode  = 0;
String strErrorMsg = "START";

try {    
    /******* JDBC Connection *******/
    Connection conn = null;
    Statement  stmt = null;
    ResultSet  rs   = null;
    
    try { 
        Class.forName("org.sqlite.JDBC");
		conn = DriverManager.getConnection("jdbc:sqlite:C:\\Tomcat 8.0\\webapps\\EduProject\\File\\nexacro_edu_db.sqlite");
        stmt = conn.createStatement();
      
        /******* SQL ************/
        String SQL;
		SQL = "SELECT DEPT_NAME     \n" +
			  "     , DEPT_CD       \n" +
			  "  FROM TB_DEPT       \n" +
			  " ORDER BY DEPT_CD    \n" ;
		
        rs = stmt.executeQuery(SQL);
		out_PlatformData.addDataSet(RsToDs(rs,"out_dept"));		
		
        nErrorCode  = 0;
        strErrorMsg = "SUCC";
        
    } catch (SQLException e) {
        nErrorCode = -1;
        strErrorMsg = e.getMessage();
    }    
    
    /******** JDBC Close ********/
    if ( stmt != null ) try { stmt.close(); } catch (Exception e) {nErrorCode = -1; strErrorMsg = e.getMessage();}
    if ( conn != null ) try { conn.close(); } catch (Exception e) {nErrorCode = -1; strErrorMsg = e.getMessage();}
            
} catch (Throwable th) {
    nErrorCode = -1;
    strErrorMsg = th.getMessage();
}

VariableList varList = out_PlatformData.getVariableList();
varList.add("ErrorCode", nErrorCode);
varList.add("ErrorMsg" , strErrorMsg);

HttpPlatformResponse pRes = new HttpPlatformResponse(response, PlatformType.CONTENT_TYPE_XML, "utf-8");
pRes.setData(out_PlatformData);

// Send data
pRes.sendData();
%>
