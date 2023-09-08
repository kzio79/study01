<%@ page import="com.study.connection.ConnectionTest" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - 게시판</title>
</head>
<body>
<h1><%= "자유게시판 - 목록" %>
</h1>
<br/>
<form action="index.jsp" method="get" >
    <table style="text-align: center; border: 1px solid #dddddd; width: 80%">
        <td>
            등록일 <input type="date" name="startdate"> -
            <input type="date" name="enddate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
            <select id="category" name="category">
                <option>카테고리</option>
                <option>JAVA</option>
                <option>JS</option>
                <option>SpringBoot</option>
                <option>Android</option>
            </select>
            <input type="search" name="searchid" id="searchid" size="35%" placeholder="검색어를 입력해 주세요(제목+작성자+내용)">
            <input type="submit" name="search" id="search" value="검색"><br>
        </td>
    </table>
    <%
        int total = 0;
        try{
            ConnectionTest t = new ConnectionTest();
            Connection conn = t.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT COUNT(*) as total FROM boardlist");

            rs.next();
            total = rs.getInt("total");

        }catch(Exception e){
            e.printStackTrace();
        }
    %>

<%--    <%--%>
<%--        int total = 0;--%>
<%--        try{--%>
<%--            ConnectionTest t = new ConnectionTest();--%>
<%--            Connection conn = t.getConnection();--%>

<%--            String searchid = (request.getParameter("searchid") != null)?request.getParameter("searchid"):"";--%>
<%--            String category = (request.getParameter("category") != null)?request.getParameter("category"):"카테고리";--%>
<%--            String startDate = request.getParameter("startdate");--%>
<%--            String endDate = request.getParameter("enddate");--%>

<%--            PreparedStatement pst;--%>

<%--            if(category.equals("카테고리")){--%>
<%--                pst = conn.prepareStatement(--%>
<%--                        "SELECT COUNT(*) as total FROM boardlist WHERE (title LIKE ? OR writer LIKE ? OR content LIKE ?) AND writedate BETWEEN ? AND ?"--%>
<%--                );--%>

<%--                pst.setString(1, "%" + searchid + "%"); //title--%>
<%--                pst.setString(2, "%" + searchid + "%"); //writer--%>
<%--                pst.setString(3, "%" + searchid + "%"); //content--%>
<%--                pst.setString(4, startDate);--%>
<%--                pst.setString(5, endDate);--%>

<%--            } else {--%>
<%--                pst = conn.prepareStatement(--%>
<%--                        "SELECT COUNT(*) as total FROM boardlist WHERE category=? AND (title LIKE ? OR writer LIKE ? OR content LIKE ?) AND writedate BETWEEN ? AND ?"--%>
<%--                );--%>

<%--                pst.setString(1,category);--%>
<%--                pst.setString(2, "%" + searchid + "%"); //title--%>
<%--                pst.setString(3, "%" + searchid + "%"); //writer--%>
<%--                pst.setString(4, "%" + searchid + "%"); //content--%>
<%--                pst.setString(5, startDate);--%>
<%--                pst.setString(6, endDate);--%>

<%--            }--%>

<%--            ResultSet rs = pst.executeQuery();--%>

<%--            rs.next();--%>
<%--            total = rs.getInt("total");--%>

<%--        }catch(Exception e){--%>
<%--            e.printStackTrace();--%>
<%--            System.out.println("error1"+e.getMessage());--%>
<%--        }--%>
<%--    %>--%>
    총 <%=total %>건
</form>

<table style="text-align: center; width: 100%">
    <thead>
    <tr>
        <th>카테고리</th>
        <th></th>
        <th>제목</th>
        <th>작성자</th>
        <th>조회수</th>
        <th>등록 일자</th>
        <th>수정 일자</th>
        <hr>
    </tr>
    </thead>
    <thead>
    <%

        //페이징 처리를 위한 변수
        int recordsPage = 10;
        int currentPage = request.getParameter("page") != null?Integer.parseInt(request.getParameter("page")):1;
        try{
            ConnectionTest t = new ConnectionTest();
            Connection conn = t.getConnection();

            int startRecodrdIndex=(currentPage-1)*recordsPage;
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM boardlist ORDER BY boardnum DESC LIMIT ?, ?");
            pst.setInt(1,startRecodrdIndex);
            pst.setInt(2,recordsPage);
            ResultSet rs = pst.executeQuery();

            while(rs.next()){

                out.println("<tr>");
                out.println("<td>" + rs.getString("category") + "</td>");
                out.println("<td>" + "</td>");
                out.println("<td><a href='content.jsp?boardnum=" +rs.getInt("boardnum")+"'style='text-decoration:none; color:black'>" + rs.getString("title") + "</a></td>");
                out.println("<td>" + rs.getString("writer") + "</td>");
                out.println("<td>" + rs.getInt("hit") + "</td>");
                out.println("<td>" + rs.getTimestamp("writedate") + "</td>");
                out.println("<td>" + (rs.getTimestamp("modifydate").equals(rs.getTimestamp("writedate")) ? "-" : rs.getTimestamp("modifydate")) + "</td>");
                out.println("</tr>");

            }
    %>

<%--<%--%>
<%--    //페이징 처리를 위한 변수--%>
<%--    int recordsPage = 10;--%>
<%--    int currentPage = request.getParameter("page") != null?Integer.parseInt(request.getParameter("page")):1;--%>
<%--    try{--%>
<%--    ConnectionTest t = new ConnectionTest();--%>
<%--    Connection conn = t.getConnection();--%>

<%--    String searchid = (request.getParameter("searchid") != null)?request.getParameter("searchid"):"";--%>
<%--    String category = (request.getParameter("category") != null)?request.getParameter("category"):"카테고리";--%>
<%--    String startDate = request.getParameter("startdate");--%>
<%--    String endDate = request.getParameter("enddate");--%>

<%--    int startRecodrdIndex=(currentPage-1)*recordsPage;--%>

<%--    PreparedStatement pst;--%>

<%--    if(category.equals("카테고리")){--%>
<%--        pst = conn.prepareStatement(--%>
<%--        "SELECT * FROM boardlist WHERE (title LIKE ? OR writer LIKE ? OR content LIKE ?) AND writedate BETWEEN ? AND ? ORDER BY boardnum DESC LIMIT ?, ?"--%>
<%--        );--%>
<%--        pst.setString(1, "%" + searchid + "%"); //title--%>
<%--        pst.setString(2, "%" + searchid + "%"); //writer--%>
<%--        pst.setString(3, "%" + searchid + "%"); //content--%>
<%--        pst.setString(4, startDate);--%>
<%--        pst.setString(5, endDate);--%>
<%--        pst.setInt(6,startRecodrdIndex);--%>
<%--        pst.setInt(7,recordsPage);--%>

<%--        System.out.println(category);--%>
<%--        System.out.println(startDate);--%>
<%--        System.out.println(endDate);--%>

<%--    }--%>
<%--    else {--%>
<%--        pst = conn.prepareStatement(--%>
<%--        "SELECT * FROM boardlist WHERE category=?  AND (title LIKE ? OR writer LIKE ? OR content LIKE ?) AND writedate BETWEEN ? AND ? ORDER BY boardnum DESC LIMIT ?, ?"--%>
<%--        );--%>
<%--        pst.setString(1,category);--%>
<%--        pst.setString(2, "%" + searchid + "%"); //title--%>
<%--        pst.setString(3, "%" + searchid + "%"); //writer--%>
<%--        pst.setString(4, "%" + searchid + "%"); //content--%>
<%--        pst.setString(5, startDate);--%>
<%--        pst.setString(6, endDate);--%>
<%--        pst.setInt(7,startRecodrdIndex);--%>
<%--        pst.setInt(8,recordsPage);--%>

<%--        System.out.println(category);--%>
<%--        System.out.println(startDate);--%>
<%--        System.out.println(endDate);--%>
<%--    }--%>
<%--    ResultSet rs = pst.executeQuery();--%>

<%--    while(rs.next()){--%>
<%--    out.println("<tr>");--%>
<%--        out.println("<td>" + rs.getString("category") + "</td>");--%>
<%--        out.println("<td>" + "</td>");--%>
<%--        out.println("<td><a href='content.jsp?boardnum=" +rs.getInt("boardnum")+"'style='text-decoration:none; color:black'>" + rs.getString("title") + "</a></td>");--%>
<%--        out.println("<td>" + rs.getString("writer") + "</td>");--%>
<%--        out.println("<td>" + rs.getInt("hit") + "</td>");--%>
<%--        out.println("<td>" + rs.getTimestamp("writedate") + "</td>");--%>
<%--        out.println("<td>" + (rs.getTimestamp("modifydate").equals(rs.getTimestamp("writedate")) ? "=" : rs.getTimestamp("modifydate")) + "</td>");--%>

<%--        out.println("</tr>");--%>
<%--    }--%>

<%--    %>--%>
    </thead>

</table>
<div style="text-align: center; margin-top: 1%; width: 100%">
    <%

            int noOfPages=(int)Math.ceil(total * 1.0/recordsPage); // 페이지 개수 계산
            for(int i=1; i<=noOfPages; i++){
                if(i == currentPage){
                    out.print(i);
                } else {
                    out.print("<a href='index.jsp?page="+i+"'>"+i+"</a>");  // 각 페이지 번호 출력 (링크 포함)
                }
            }

        }catch(Exception e){
            e.printStackTrace();
        }
    %>
</div>
<table style="text-align: right; width: 80%">
    <tr>
        <td colspan="5">
            <form action="write.jsp" class="form-inline" method="post">
                <div class="form-group">
                    <input type="submit" value="등록" class="btn btn-primary" size="20">
                </div>
            </form>
        </td>
    </tr>
</table>
</body>
</html>
