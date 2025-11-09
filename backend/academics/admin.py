from django.contrib import admin
from .models import College, Branch, Subject, PreviousYearQuestion, Moderator


@admin.register(College)
class CollegeAdmin(admin.ModelAdmin):
    list_display = ['name', 'location', 'created_at']
    search_fields = ['name', 'location']
    list_filter = ['created_at']
    ordering = ['name']


@admin.register(Branch)
class BranchAdmin(admin.ModelAdmin):
    list_display = ['name', 'code', 'college']
    search_fields = ['name', 'code', 'college__name']
    list_filter = ['college']
    ordering = ['college', 'name']


@admin.register(Subject)
class SubjectAdmin(admin.ModelAdmin):
    list_display = ['name', 'code', 'branch', 'get_college']
    search_fields = ['name', 'code', 'branch__name', 'branch__college__name']
    list_filter = ['branch__college', 'branch']
    ordering = ['branch', 'name']

    def get_college(self, obj):
        return obj.branch.college.name
    get_college.short_description = 'College'


@admin.register(PreviousYearQuestion)
class PreviousYearQuestionAdmin(admin.ModelAdmin):
    list_display = ['subject', 'year', 'semester', 'regulation', 'uploaded_by', 'approved', 'uploaded_at']
    search_fields = ['subject__name', 'year', 'regulation', 'uploaded_by__username']
    list_filter = ['approved', 'year', 'semester', 'subject__branch__college', 'uploaded_at']
    ordering = ['-uploaded_at']
    actions = ['approve_pyqs', 'unapprove_pyqs']

    def approve_pyqs(self, request, queryset):
        updated = queryset.update(approved=True)
        self.message_user(request, f'{updated} PYQs were successfully approved.')
    approve_pyqs.short_description = "Approve selected PYQs"

    def unapprove_pyqs(self, request, queryset):
        updated = queryset.update(approved=False)
        self.message_user(request, f'{updated} PYQs were unapproved.')
    unapprove_pyqs.short_description = "Unapprove selected PYQs"


@admin.register(Moderator)
class ModeratorAdmin(admin.ModelAdmin):
    list_display = ['user', 'college', 'role', 'is_active', 'created_at']
    search_fields = ['user__username', 'user__email', 'college__name', 'role']
    list_filter = ['is_active', 'college', 'created_at']
    ordering = ['college', 'user']
