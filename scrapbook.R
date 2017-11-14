

# Massive faceted bar plot showing how values are distributed in variables
df %>% gather(key = "var", value = "value", -c(Points, Age, Attitude, row_id, gender)) %>%
  ggplot() +
  geom_bar(aes(x=as.factor(value), fill = gender)) +
  facet_wrap(~var)

# Histgrams of non-likert variables
df %>% gather(key = "var", value = "value", c(Points, Age, Attitude)) %>%
  ggplot() +
  geom_density(aes(x=value, fill = gender, alpha = .2)) +
  facet_wrap(~var, scales = "free")

ggscatmat(as.data.frame(analysis), columns = 2:7, color = "gender", alpha = .5)

model <- lm(Points ~ Attitude, data = analysis)
model2 <- lm(Points ~ Attitude + Age, data = analysis)
summary(model)
gg <- model.matrix(model)[,2]
gg


a <- (analysis$Attitude-mean(analysis$Attitude))^2/sum((analysis$Attitude-mean(analysis$Attitude))^2)+1/nrow(analysis)
b <- hatvalues(model)
a-b

a <- scale(model$residuals)
b <- rstandard(model)
c <- rstudent(model)
d <- model$residuals/sqrt(mean(model$residuals^2))
e <- model$residuals/(sd(model$residuals)*sqrt(1-hat(model.matrix(model))))
f <- model$residuals/sd(model$residuals)
g <- 
b-a
b-c
b-d
b-e
head(cbind(a,b,c,d,e, f,g))



a <- plot(model, which = c(1,2), add.smooth = T)


# model vs resid 


attitude <- analysis$Attitude
fitted <- fitted(model)
residuals <- residuals(model)
norm.res <- model$residuals/(sqrt(deviance(model)/df.residual(model))*sqrt(1-hatvalues(model)))
leverage <- as.numeric((attitude-mean(attitude))^2/sum((attitude-mean(attitude))^2)+1/length(attitude))
cooks <- cooks.distance(model)
d <- data.frame(id = 1:166, attitude, fitted, residuals, norm.res, leverage, cooks)
d

p1 <- plot_ly(d, x = ~fitted, y = ~residuals, type = 'scatter', mode = 'markers',
             text = ~paste('Id: ', id), hoverinfo = "text")

p2 <- plot_ly(d, x = ~leverage, y = ~norm.res, type = 'scatter', mode = 'markers',
              text = ~paste('Id: ', id), hoverinfo = "text")

subplot(p1,p2)
p3 <-
ggplotly(p3, tooltip = "text")


b <- ggplot(analysis, aes(leverage, norm.res)) + 
  geom_point() +
  xlab("Leverage") + ylab ("Standardized residuals")
b
ggplotly(b, hoverinfo == "name")

c <- plot(cooks.distance(model), norm.res, xlab = "Cook's distance", ylab = "Standardized residuals")
c


ggplot(canada.cities, aes(long, lat)) +
  borders(regions = "canada") +
  coord_equal() +
  geom_point(aes(text = name, size = pop), colour = "red", alpha = 1/2)

library(plotly)

xdat <- c("Bob Dylan", "The Beatles", "David Bowie", "Randy Newman", "The Rolling Stones", "Madonna", "Frank Sinatra", "The Beach Boys", "Marvin Gaye", "Prince", "The Kinks", "Elvis Presley", "Tom Waits", "U2", "The Clash", "Johnny Cash", "Kate Bush", "The Supremes", "The Smiths", "Al Green", "Pulp", "Chuck Berry", "Elvis Costello and the Attractions", "Neil Young", "Stevie Wonder", "Ray Charles", "The Pogues", "Grace Jones", "Bill Withers", "The Who", "Paul Simon", "Roy Orbison", "Arctic Monkeys", "Bruce Springsteen", "The Police", "Rod Stewart", "Steve Earle")

ydat <- c(24, 19, 9, 8, 8, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)

p <- plot_ly(x = xdat,  y =ydat,  name = "Number",
             marker = list(color = "#2ca02c"),
             type = "bar", filename="hover_example")
p
