# Nexus

Nexus is a Flutter + Supabase app for technical learning (DSA and similar subjects).

The app uses a content hierarchy:

`Subject -> Chapter -> Topic -> Subtopic -> Slides`

Slides are rendered from Supabase in three formats:

- `slide` (markdown lesson content)
- `slide_mcq` (multiple-choice question)
- `slide_match` (match-the-pairs interaction)

## Tech Stack

- Flutter (Material 3)
- Supabase (`supabase_flutter`)
- Riverpod + Hooks (`hooks_riverpod`, `riverpod_annotation`, `flutter_hooks`)
- Freezed + JSON serialization (`freezed`, `json_serializable`, `freezed_annotation`, `json_annotation`)
- Markdown rendering (`flutter_markdown_plus`)
- Environment configuration (`flutter_dotenv`)
- Logging (`logger`)

## App Flow (Detailed)

## 1) App Bootstrap

1. `main.dart` initializes Flutter bindings.
2. `.env` is loaded using `flutter_dotenv`.
3. Supabase is initialized with `SUPABASE_URL` and `SUPABASE_KEY`.
4. App starts inside `ProviderScope`.
5. Home widget is `AuthGate`.

## 2) Authentication Flow

1. `AuthGate` watches `authStateProvider`.
2. If session exists, user goes to `TabWidgetTree`.
3. If session does not exist, user sees `LoginPage`.
4. `LoginForm` uses `supabase.auth.signInWithPassword`.
5. `SignupForm` uses `supabase.auth.signUp`.
6. `ProfilePage` can trigger `supabase.auth.signOut`.

Routing is session-driven: successful auth updates state and `AuthGate` switches screens automatically.

## 3) Main Navigation Flow

`TabWidgetTree` uses a bottom `NavigationBar` with:

- Home
- Search
- Profile

Each tab is rendered as a page in the main scaffold body.

## 4) Learning Content Flow

The learning browse journey is:

1. Home/Search shows subjects (from provider data).
2. Tap subject -> `ChaptersPage`
3. Tap chapter -> `TopicsPage`
4. Tap topic -> `SubtopicsPage`
5. Tap subtopic -> `SlideViewerPage`

This is implemented with providers in `lib/core/providers/content_provider.dart`:

- `subjectProvider`
- `chapterProvider(subjectId)`
- `topicProvider(chapterId)`
- `subtopicProvider(topicId)`

## 5) Slide Viewer Flow

`SlideViewerPage` loads `slidesProvider(subtopicId)`.

`slidesProvider` returns a `SlidesForSubtopic` object containing:

- `slides`
- `mcqSlides`
- `matchSlides`

`SlideViewerBody` then:

1. Merges all slide types into one ordered sequence by `order`.
2. Shows progress using segmented progress UI.
3. Locks forward navigation for interactive slides until completion.
4. Uses `Next` and `Back` controls for lesson movement.
5. Ends lesson on `Finish`.

### Slide Types

- `ContentSlideWidget`: Markdown lesson content and key points.
- `McqSlideWidget`: Option selection, correctness feedback, explanation.
- `MatchSlideWidget`: Left-right matching flow with completion tracking.

## Architecture and Data Flow

App layers follow this pattern:

`Supabase Service -> Riverpod Provider -> UI Page/Widget`

### Services

- Located in `lib/core/services/`
- Static methods only
- Responsible for Supabase table queries and mapping JSON to models

### Providers

- Located in `lib/core/providers/`
- Generated via `riverpod_generator`
- Wrap services and expose async state to UI

### Models

- Located in `lib/core/models/`
- Freezed immutable classes + `fromJson` factories

## Folder Structure

```text
nexus/

	assets/
		images/

	lib/
		main.dart

		core/
			singleton.dart                  # global supabase client + logger
			models/
				chapter.dart
				slide.dart
				slide_match.dart
				slide_mcq.dart
				subject.dart
				subtopic.dart
				topic.dart
				*.freezed.dart
				*.g.dart
			providers/
				auth_provider.dart
				content_provider.dart
				slide_provider.dart
				*.g.dart
			services/
				chapter_service.dart
				slide_service.dart
				subject_service.dart
				subtopic_service.dart
				topic_service.dart

		pages/
			tab_widget_tree.dart

			auth/
				login.dart
				signup.dart
				widgets/
					login_form.dart
					signup_form.dart

			content/
				subjects_page.dart
				chapters_page.dart
				topics_page.dart
				subtopics_page.dart
				widgets/
					subject_card.dart
					chapter_card.dart
					topic_card.dart
					subtopic_card.dart

			slides/
				slide_viewer_page.dart
				widgets/
					slide_viewer_body.dart
					segmented_progress.dart
					content_slide.dart
					mcq_slide.dart
					match_slide.dart

			tabs/
				home_page.dart
				search_page.dart
				profile_page.dart
				widgets/
					subject_grid.dart

	supabase/
		config.toml
		migrations/

	test/
		widget_test.dart

	pubspec.yaml
	analysis_options.yaml
```

## Setup

Create a `.env` in project root:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_KEY=your_supabase_anon_key
```

Also ensure `.env` is included in assets in `pubspec.yaml`.

## Development Commands

```bash
flutter pub get
dart run build_runner build -d
flutter run
flutter analyze
flutter test
```

Use watch mode when frequently changing providers/models:

```bash
dart run build_runner watch -d
```

## Conventions Used In This Project

- Services are static (no service instances)
- Providers are annotated with `@riverpod`
- JSON uses snake_case and maps to Dart camelCase via `@JsonKey`
- UI consumes providers using `HookWidget` / `ConsumerWidget` / `HookConsumerWidget`

## Current Learning Scope

- Auth: email/password login + signup + logout
- Content browsing: subject to subtopic fully wired
- Slide viewer: content + MCQ + match interactions

Next enhancement area: progress tracking, XP/streak persistence, and lesson analytics.
