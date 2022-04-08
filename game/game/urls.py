from django.urls import path
from django.contrib import admin
from tycoon import views

urlpatterns = [
    path("", views.home),
    path("admin/", admin.site.urls)
]
