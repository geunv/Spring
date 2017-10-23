package com.spring.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger.web.UiConfiguration;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableWebMvc
@EnableSwagger2
public class SwaggerConfiguration extends WebMvcConfigurerAdapter{
	
	@Bean
	public Docket api(){
		
		//http://localhost:8080/swagger-ui.html#/
		
		boolean swaggerEnable = true;
		
	    return new Docket(DocumentationType.SWAGGER_2)
	    .select()
	    .apis(RequestHandlerSelectors.any())	// 현재 RequestMapping으로 할당된 모든 URL 리스트를 추출
	    .paths(springfox.documentation.builders.PathSelectors.regex("/api.*")) // 그중 /api.* 인 URL들만 필터링
	    //.paths(springfox.documentation.builders.PathSelectors.any())
	    .build()
	    .enable(swaggerEnable)
	    .apiInfo(apiInfo());
	}
	
	@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("swagger-ui.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }
	
	private ApiInfo apiInfo() {		
	    ApiInfo apiInfo = new ApiInfo("Api Documentation", "Api Documentation", "1.0", "urn:tos", "Contact Email", "Apache 2.0", "http://www.apache.org/licenses/LICENSE-2.0");
	    return apiInfo;
	}
	
	 @Bean
	  UiConfiguration uiConfig() {
	    return new UiConfiguration(
	        "/v2/api-docs",// url
	        "list",       // docExpansion          => none | list
	        "alpha",      // apiSorter             => alpha
	        "schema",     // defaultModelRendering => schema
	        UiConfiguration.Constants.DEFAULT_SUBMIT_METHODS,
	        true,        // enableJsonEditor      => true | false
	        true,         // showRequestHeaders    => true | false
	        60000L);      // requestTimeout => in milliseconds, defaults to null (uses jquery xh timeout)
	  }
}


