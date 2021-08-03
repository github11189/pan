package beans;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;

public class HdfsDao {
	// 根目录
	String url = "hdfs://192.168.112.90:9000/";

	public FileStatus[] Brower() {
		FileStatus[] list = null;
		try {

			Configuration conf = new Configuration();
			FileSystem fs = FileSystem.get(URI.create(url), conf);
			list = fs.listStatus(new Path(url));

//			for (int i = 0; i < list.length; i++) {
//				System.out.println( list[i].getPath().toString()+",isDirectory:"+list[i].isDirectory());
//			}

			// 关闭资源
			fs.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return list;

	}

	public FileStatus[] Brower(String tmp) {
		FileStatus[] list = null;
		try {
			Configuration conf = new Configuration();
			String hdfsurl = tmp;
			FileSystem fs = FileSystem.get(URI.create(hdfsurl), conf);
			list = fs.listStatus(new Path(hdfsurl));

//			for (int i = 0; i < list.length; i++) {
//				System.out.println( list[i].getPath().toString()+",isDirectory:"+list[i].isDirectory());
//			}

			// 关闭资源
			fs.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return list;

	}

	// 创建新目录
	public void createdir(String dirpath) {
		try {
			String dirname = dirpath;
			Configuration conf = new Configuration();
			FileSystem fs = FileSystem.get(URI.create(dirname), conf);
			Path f = new Path(dirname);
			if (!fs.exists(new Path(dirname))) {
				// fs.create(f);
				fs.mkdirs(f);
			}

			System.out.println("ok");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// 上传
	public void copyFile(String local, String hdfsPath) throws IOException {
		Configuration conf = new Configuration();
		FileSystem fs = FileSystem.get(URI.create(hdfsPath), conf);
		// remote---/用户/用户下的文件或文件夹
		fs.copyFromLocalFile(new Path(local), new Path(hdfsPath));
		System.out.println("copy from: " + local + " to " + hdfsPath);
		fs.close();
	}

	// 获取文件输入流
	public InputStream getFileInputStreamForPath(String strpath) throws IOException {
		Configuration conf = new Configuration();
		conf.set("fs.default.name", strpath);
		FileSystem fs = FileSystem.get(conf);
		return fs.open(new Path(strpath));
	}

	// 删除
	public void delete(String deletePath) {
		try {
			Configuration conf = new Configuration();
			FileSystem fs = FileSystem.get(URI.create(deletePath), conf);
			fs.deleteOnExit(new Path(deletePath));
			fs.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
