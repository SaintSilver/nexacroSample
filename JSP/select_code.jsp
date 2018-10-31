<%@ page import = "org.apache.commons.logging.*" %>
<%@ page import = "com.nexacro17.xapi.data.*" %>
<%@ page import = "com.nexacro17.xapi.tx.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page contentType = "text/xml; charset=UTF-8" %>

<%!
// ResultSet ==> Dataset
public DataSet RsToDs(ResultSet rs, String dsID) throws Exception
{
	int i;
	int iColCnt;
	String sColName;
	String sColType;;
	int ColType = 0; 
	int ColSize = 255; 
	
	DataSet ds = new DataSet(dsID);
	ResultSetMetaData rsmd = rs.getMetaData();

	iColCnt = rsmd.getColumnCount();
	for( i = 1 ; i <= iColCnt ; i++ )
	{
		sColName = rsmd.getColumnName(i).toUpperCase();		
		sColType = rsmd.getColumnTypeName(i);

		ColType = DataTypes.STRING;
		if(sColType.equals("INTEGER"))	ColType = DataTypes.INT;
		if(sColType.equals("DECIMAL"))	ColType = DataTypes.DECIMAL;
		
		ds.addColumn(sColName, ColType, ColSize);		
	}
	while(rs.next())
	{
		int row = ds.newRow();
		for( i = 1 ; i <= iColCnt ; i++ )
		{
			sColName = rsmd.getColumnName(i).toUpperCase();
			ds.set(row, sColName, rsGet(rs, sColName));
		}
	}

  return ds;
}

public String rsGet(ResultSet rs, String id) throws Exception
{
	if( rs.getString(id) == null ){
		return "";
	} 
	else {
		return rs.getString(id);
	}
}
%>

<%
// PlatformData
PlatformData out_pData = new PlatformData();
    
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
      
        String SQL;
		
		SQL = " SELECT DEPT_CD, DEPT_NAME FROM TB_DEPT";			
        rs = stmt.executeQuery(SQL);
		out_pData.addDataSet(RsToDs(rs,"out_dept"));		
         
		SQL = " SELECT POS_CD, POS_NAME FROM TB_POS";
        rs = stmt.executeQuery(SQL);
		out_pData.addDataSet(RsToDs(rs,"out_pos"));		
		
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

VariableList varList = out_pData.getVariableList();
varList.add("ErrorCode", nErrorCode);
varList.add("ErrorMsg" , strErrorMsg);

HttpPlatformResponse pRes = new HttpPlatformResponse(response, PlatformType.CONTENT_TYPE_XML, "utf-8");
pRes.setData(out_pData);

pRes.sendData();
%>
