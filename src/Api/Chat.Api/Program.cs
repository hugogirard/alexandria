var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();
app.UseHttpsRedirection();

app.MapGet("/weatherforecast", () =>
{
    return "test";
})
.WithName("GetWeatherForecast")
.WithOpenApi();

app.Run();