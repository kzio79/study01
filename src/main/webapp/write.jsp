<%@ page import="com.study.connection.ConnectionTest" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>

<html>
<head>
    <title>JSP - 게시판</title>
</head>
<body>
<h1><%= "게시판 - 등록" %>
</h1>
<br/>

<div>
    <div style="margin-top: 2%; margin-left:5%;" >
        <div align="center"  style="margin-top: 5%;">
            <form style="margin-bottom: 5%; margin-top: 2%" method="post">
                <table style= "width:80%;">
                    <tr>
                        <td style="color: black; font-weight: bolder;">
                            카테고리&nbsp;<select id="category" name="category">
                            <option value="">카테고리 선택</option>
                            <option value="JAVA">JAVA</option>
                            <option value="JS">JS</option>
                            <option value="SpringBoot">SpringBoot</option>
                            <option value="Android">Android</option>
                        </select>
                    </tr>
                    <tr>
                        <td style="color: black; font-weight: bolder;">
                            작성자&nbsp;<input type="text" name="writer" id="writer"></td>
                    </tr>
                    <tr>
                        <td style="color: black; font-weight: bolder;">
                            비밀번호&nbsp;<input type="password" name="pw" id="pw" placeholder="비밀번호">
                                        <input type="password" name="pwcheck" id="pwcheck" placeholder="비밀번호확인"></td>
                    </tr>
                    <tr>
                        <td style="color: black; font-weight: bolder;">
                            글제목&nbsp;<input type="text" name="title" id="title" style="width: 90%;" class="click"></td>
                    </tr>
                    <tr>
                        <td style="color: black; font-weight: bolder;">
                            글내용<textarea rows="12" style="width:100%;" class="click" name="content" id="content"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="color: black; font-weight: bolder;">
                            파일첨부&nbsp;<input type="text" name="file"> <input type="file" value="파일 찾기"><br>
                            <input type="text" name="file2"> <input type="button" value="파일 찾기"><br>
                            <input type="text" name="file3"> <input type="button" value="파일 찾기"><br>
                        </td>
                    </tr>
                    <tr style="margin-bottom: 5%">
                        <!-- 글 수정 메뉴 -->
                        <td colspan="2" align="center" style="margin-bottom: 5%">
                            <input type="button" class="btn btn-primary" value="취소" onclick="location.href='index.jsp'">
                            <input type="submit" class="btn btn-primary" value="저장" >
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>

<%
if("POST".equalsIgnoreCase(request.getMethod())){
    request.setCharacterEncoding("UTF-8");

    String category = request.getParameter("category");
    String title = request.getParameter("title");
    String writer = request.getParameter("writer");
    String pw = request.getParameter("pw");
    String pwcheck = request.getParameter("pwcheck");
    String content = request.getParameter("content");

    if(pw != null && !pw.isEmpty() && pw.equals(pwcheck)){
        try{
            if(!category.equals("카테고리 선택")){
                ConnectionTest t = new ConnectionTest();
                Connection conn = t.getConnection();

                PreparedStatement ps = conn.prepareStatement("INSERT INTO boardlist (category,title,writer,pw,content) VALUES (?,?,?,?,?)");

                ps.setString(1,category);
                ps.setString(2,title);
                ps.setString(3,writer);
                ps.setString(4,pw);
                ps.setString(5,content);

                System.out.println(category);
                System.out.println(title);
                System.out.println(writer);
                System.out.println(pw);
                System.out.println(content);

                int result = ps.executeUpdate();

                if(result >0){
                    out.print("<script>alert('게시물이 등록되었습니다.');location.href='index.jsp';</script>");
                    return;
                } else {
                    out.print("<script>alert('게시물 등록이 실패했습니다.');history.back();</script>");
                }
                ps.close();
                conn.close();
            } else {
                out.print("<script>alert('카테고리를 확인해주세요.');history.back();</script>");
            }

        } catch (Exception e){
            e.printStackTrace();
        }
    } else if(pw != null && !pw.isEmpty()){
        out.print("<script>alert('비밀번호를 확인해주세요.');history.back();</script>");
    }
}

%>
</body>
</html>
