package com.example.gt_events.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.InputStream;


@Service
public class FileService {
    private static final Logger LOGGER = LoggerFactory.getLogger(FileService.class);

    private final AmazonS3 amazonS3;

    @Autowired
    public FileService(AmazonS3 amazonS3) {
        this.amazonS3 = amazonS3;
    }

    @Value("${s3.bucket.name}")
    private String s3BucketName;

    public void uploadStream(String key, InputStream inputStream) {
        PutObjectRequest putObjectRequest = new PutObjectRequest(s3BucketName, key, inputStream, new ObjectMetadata());
        amazonS3.putObject(putObjectRequest);
    }

    public S3ObjectInputStream downloadStream(String key) {
        GetObjectRequest getObjectRequest = new GetObjectRequest(s3BucketName, key);
        return amazonS3.getObject(getObjectRequest).getObjectContent();
    }
}