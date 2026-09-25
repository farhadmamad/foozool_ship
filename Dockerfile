# فاز ۱ — نصب وابستگی‌ها
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# v3.9.2: libfribidi برای رندر RTL — Pillow wheel کتابخانهٔ raqm را باندل می‌کند ولی
# fribidi را در زمان اجرا از سیستم load می‌کند؛ بدون این، direction="rtl" خطا می‌دهد
# و لیدربورد تصویری به حالت متنی برمی‌گردد.
RUN apt-get update && apt-get install -y --no-install-recommends libfribidi0 libharfbuzz0b \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# کد ربات — v3.13+: wheel_video.py (موتور MP4 چرخ شانس) هم باید در ایمیج باشد
COPY texts.py config.py main.py tasks.py leaderboard_img.py wheel_gif.py wheel_video.py ./

# فونت‌های وزیرمتن برای لیدربورد تصویری
COPY fonts/ ./fonts/

CMD ["python", "main.py"]
