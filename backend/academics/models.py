from django.db import models
from django.contrib.auth.models import User


class College(models.Model):
    """Model representing a college/university"""
    name = models.CharField(max_length=255)
    location = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

    class Meta:
        ordering = ['name']


class Branch(models.Model):
    """Model representing a branch/department in a college"""
    college = models.ForeignKey(College, on_delete=models.CASCADE, related_name='branches')
    name = models.CharField(max_length=255)
    code = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return f"{self.name} - {self.college.name}"

    class Meta:
        ordering = ['college', 'name']
        unique_together = ['college', 'name']


class Subject(models.Model):
    """Model representing a subject in a branch"""
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE, related_name='subjects')
    name = models.CharField(max_length=255)
    code = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return f"{self.name} - {self.branch.name}"

    class Meta:
        ordering = ['branch', 'name']
        unique_together = ['branch', 'name']


class PreviousYearQuestion(models.Model):
    """Model representing a Previous Year Question (PYQ)"""
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE, related_name='pyqs')
    year = models.IntegerField()
    semester = models.IntegerField()
    regulation = models.CharField(max_length=100, blank=True, null=True)
    paper_file = models.FileField(upload_to='pyq_papers/')
    uploaded_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='uploaded_pyqs')
    approved = models.BooleanField(default=False)
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.subject.name} - {self.year} (Sem {self.semester})"

    class Meta:
        ordering = ['-year', 'semester', 'subject']
        unique_together = ['subject', 'year', 'semester', 'regulation']


class Moderator(models.Model):
    """Model representing a moderator for a college"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='moderated_colleges')
    college = models.ForeignKey(College, on_delete=models.CASCADE, related_name='moderators')
    is_active = models.BooleanField(default=True)
    role = models.CharField(max_length=100, blank=True, null=True, help_text="Role or permissions description")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.college.name}"

    class Meta:
        ordering = ['college', 'user']
        unique_together = ['user', 'college']
