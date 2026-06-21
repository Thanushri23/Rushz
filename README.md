# Rushz 🎮🎬🏸

A cross-platform booking app for movie cabins, gaming cabins, and outdoor sports courts — built with **Flutter** and **Supabase**.

Rushz solves a real scheduling problem: small entertainment venues (arcades, mini cinemas, sports courts) often manage bookings manually over phone calls or WhatsApp. Rushz gives them a proper dual-sided platform — one app, two experiences.

## Features

**For Customers**
- Browse available movie/gaming cabins and outdoor sports courts
- Book a slot in real time, with instant confirmation
- View and manage upcoming bookings

**For Admins (Venue Owners)**
- Manage cabin/court inventory and availability
- View, confirm, and track incoming bookings
- Separate admin dashboard, isolated from the customer interface

**Booking Logic**
- Cabin-based booking for indoor activities (movies, gaming)
- Court-based booking for outdoor sports
- Full end-to-end flow: browse → select slot → book → confirm → manage

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) — Android, iOS, Web |
| Backend | Supabase (PostgreSQL database, Auth, real-time subscriptions) |
| State Management | _[fill in: Provider / Riverpod / Bloc / GetX / setState]_ |
| Auth | Supabase Auth — role-based access (Admin / Customer) |

## Getting Started

```bash
git clone https://github.com/Thanushri23/Rushz.git
cd Rushz
flutter pub get
flutter run
```

You'll need a Supabase project set up with the relevant tables for venues, cabins/courts, bookings, and user roles. _[Add `.env` / config setup instructions here if applicable]_

## Status

Core booking flow is fully functional end-to-end for both customer and admin roles. _[Add anything in progress, e.g. payments, notifications, ratings]_

## What I'd Improve Next

_[Optional but recommended — shows growth mindset to recruiters, e.g. "Add payment gateway integration", "Push notifications for booking reminders", "Admin analytics dashboard"]_

---

Built by [Your Name] — [LinkedIn] · [Portfolio]
