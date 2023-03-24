package com.example.gt_events.controller;

import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.example.gt_events.service.FileService;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/files")
public class FileController {
    private final FileService fileService;

    @Autowired
    public FileController(FileService fileService) {
        this.fileService = fileService;
    }

    @GetMapping("/{fileKey}")
    public void handleFileDownload(@PathVariable String fileKey, HttpServletResponse response) throws IOException {
        S3ObjectInputStream inputStream = fileService.downloadStream(fileKey);
        IOUtils.copy(inputStream, response.getOutputStream());
        inputStream.close();
        response.flushBuffer();
    }
}
