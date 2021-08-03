package beans;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.http.HttpHost;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.IndicesClient;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.core.CountRequest;
import org.elasticsearch.client.core.CountResponse;
import org.elasticsearch.common.text.Text;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.elasticsearch.search.sort.SortOrder;

public class EsDao {

	public void writeEs(String path) {
		try {
			HttpHost httpHost = new HttpHost("192.168.112.80", 9200, "http");
			RestClientBuilder restClientBuilder = RestClient.builder(httpHost);
			// 连接ES
			RestHighLevelClient esClient = new RestHighLevelClient(restClientBuilder);

			// 写入数据到ES
			boolean flag = index(esClient, path, "cv");
			System.out.println("文档写入ES是否成功：" + flag);

			// 99 关闭资源
			esClient.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public boolean index(RestHighLevelClient esClient, String path, String index) throws IOException {
		// 读取文件
		String ctStr = "";
		BufferedReader in = null;
		File file = new File(path);
		String fileName = file.getName();
		String category = file.isFile() ? "file" : "directory";
		String suffix = fileName.substring(fileName.lastIndexOf(".") + 1);
		long length = file.length() / 1024;
		try {
			in = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"));// 读取文件
			String thisLine = null;
			while ((thisLine = in.readLine()) != null) {
				ctStr += thisLine;
			}
			in.close();
			System.out.println(ctStr);
		} catch (IOException e) {
			e.printStackTrace();
		}

		// 按文档数量生成一个文档ID号
		IndexRequest indexRequest = new IndexRequest(index);
		IndicesClient indices = esClient.indices();
		CountRequest countRequest = new CountRequest(index);
		CountResponse count = esClient.count(countRequest, RequestOptions.DEFAULT);
		String id = (count.getCount() + 1) + "";
		indexRequest.id(id);

		String source = "{\r\n" + "  \"category\":\"" + category + "\",\r\n" + "  \"suffix\":\"" + suffix + "\",\r\n"
				+ "  \"name\":\"" + fileName + "\",\r\n" + "  \"path\":\"" + path + "\",\r\n" + "  \"size\":\"" + length
				+ "\",\r\n" + "  \"content\":\"" + ctStr + "\"\r\n" + "}";
		indexRequest.source(source, XContentType.JSON);
		IndexResponse index2 = esClient.index(indexRequest, RequestOptions.DEFAULT);
		return true;
	}

	public SearchHit[] search(String params) throws IOException {
		HttpHost httpHost = new HttpHost("192.168.112.80", 9200, "http");
		RestClientBuilder restClientBuilder = RestClient.builder(httpHost);
		// 连接ES
		RestHighLevelClient esClient = new RestHighLevelClient(restClientBuilder);
		
		SearchRequest searchRequest = new SearchRequest("cv");

		// 条件查询
		SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
		// 1 termQuery
//		QueryBuilder query=QueryBuilders.termQuery("age", 25);
		// 2 termsQuery
//		QueryBuilder query=QueryBuilders.termsQuery("age", "25","28");
		// 3 matchAllQuery
//		QueryBuilder query=QueryBuilders.matchAllQuery();
		// 4 matchQuery
		QueryBuilder query = QueryBuilders.matchQuery("content", params);
		// 5 multiMatchQuery
//		QueryBuilder query=QueryBuilders.multiMatchQuery("小李","customerName","addr");
		// 6 fuzzyQuery
//		QueryBuilder query=QueryBuilders.fuzzyQuery("customCode", "1024").fuzziness(Fuzziness.ONE);
		// 7 rangeQuery
//		QueryBuilder query=QueryBuilders.rangeQuery("age").gte(18).lte(28);
		// 8 boolQuery
//		QueryBuilder query=QueryBuilders.boolQuery()
//							.must(QueryBuilders.rangeQuery("age").gte(18).lte(25))
//							.must(QueryBuilders.matchQuery("sex", "1"));
		// 9 组合
//				QueryBuilder query=QueryBuilders.boolQuery()
//						.must(QueryBuilders.rangeQuery("age").gte(20).lte(28))
//						.filter(QueryBuilders.boolQuery()
//								.should(QueryBuilders.matchQuery("fav", "changge"))
//								.should(QueryBuilders.matchQuery("fav", "tiaowu"))
//								)
////						.should(QueryBuilders.matchQuery("fav", "changge"))
////						.should(QueryBuilders.matchQuery("fav", "tiaowu"))
//						.mustNot(QueryBuilders.matchQuery("age", 25));

		sourceBuilder.query(query);

//		sourceBuilder.sort("age", SortOrder.DESC);
		// gaoliang
		HighlightBuilder highlightBuilder = new HighlightBuilder();
		highlightBuilder.field("content");
		highlightBuilder.preTags("<h2 style=\"color:red\">");
		highlightBuilder.postTags("</h2>");
		sourceBuilder.highlighter(highlightBuilder);
		searchRequest.source(sourceBuilder);

		SearchResponse search = esClient.search(searchRequest, RequestOptions.DEFAULT);
		System.out.println(search);
		SearchHits hits = search.getHits();
		SearchHit[] hits2 = hits.getHits();

		for (SearchHit searchHit : hits2) {
			
			String sourceAsString = searchHit.getSourceAsString();
			System.out.println(sourceAsString);
			Map<String, Object> sourceAsMap = searchHit.getSourceAsMap();
			System.out.println(sourceAsMap);
			System.out.println("----------------------------");
			System.out.println("category: "+sourceAsMap.get("category"));
			System.out.println("name: "+sourceAsMap.get("name"));
			System.out.println("path: "+sourceAsMap.get("path"));
			System.out.println("size: "+sourceAsMap.get("size"));
			System.out.println("content: "+sourceAsMap.get("content"));
			System.out.println("----------------------------");
			for (Entry<String, Object> entry : sourceAsMap.entrySet()) {
				
				System.out.println(entry.getKey() + "\t" + entry.getValue());
			}

		    Map<String, HighlightField> highlightFields = searchHit.getHighlightFields();
		    HighlightField highlight = highlightFields.get("content"); 
		    Text[] fragments = highlight.fragments();  
		    String fragmentString = fragments[0].string();
		    System.out.println("------------fragmentString----------------");
		    System.out.println(fragmentString);
		}
		
		return hits2;

	}
}
