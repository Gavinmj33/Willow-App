//
//  QuoteManager.swift
//  Willow
//
//  Created by Matthew Gavin on 12/12/25.
//
import Foundation
import Combine

class QuoteManager: ObservableObject, QuoteProviding {
    static let shared = QuoteManager()
    
    @Published private(set) var quotes: [Quote] = []
    
    private let lastDateKeyPrefix = "lastQuoteDate_"
    private let currentIndexKeyPrefix = "currentQuoteIndex_"
    
    init() {
        loadQuotes()
    }
    
    // MARK: - Get Today's Quote
    
    func getTodaysQuote(for period: Quote.TimePeriod) -> Quote? {
        let periodQuotes = quotes.filter { $0.period == period }
        guard !periodQuotes.isEmpty else { return nil }
        
        let today = Calendar.current.startOfDay(for: Date())
        let lastDateKey = lastDateKeyPrefix + period.rawValue
        let indexKey = currentIndexKeyPrefix + period.rawValue
        
        let lastDate = UserDefaults.standard.object(forKey: lastDateKey) as? Date
        var currentIndex = UserDefaults.standard.integer(forKey: indexKey)
        
        if let lastDate = lastDate {
            let lastDay = Calendar.current.startOfDay(for: lastDate)
            if today > lastDay {
                currentIndex = (currentIndex + 1) % periodQuotes.count
                UserDefaults.standard.set(currentIndex, forKey: indexKey)
                UserDefaults.standard.set(today, forKey: lastDateKey)
            }
        } else {
            UserDefaults.standard.set(today, forKey: lastDateKey)
            UserDefaults.standard.set(currentIndex, forKey: indexKey)
        }
        
        return periodQuotes[currentIndex]
    }
    
    func getCurrentPeriod() -> Quote.TimePeriod {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            return .morning
        case 12..<17:
            return .day
        case 17..<21:
            return .evening
        default:
            return .night
        }
    }
    
    // MARK: - Load Quotes
    
    private func loadQuotes() {
        quotes = [
            // MARK: - Morning Quotes (60)
            
            Quote(text: "This is a wonderful day. I have never seen this one before.", author: "Maya Angelou", period: .morning),
            Quote(text: "The sun is new each day.", author: "Heraclitus", period: .morning),
            Quote(text: "Every morning brings new potential, but if you dwell on the misfortunes of the day before, you tend to overlook tremendous opportunities.", author: "Harvey Mackay", period: .morning),
            Quote(text: "An early-morning walk is a blessing for the whole day.", author: "Henry David Thoreau", period: .morning),
            Quote(text: "There was never a night or a problem that could defeat sunrise or hope.", author: "Bernard Williams", period: .morning),
            Quote(text: "First thing every morning before you arise, say out loud, I believe.", author: "Norman Vincent Peale", period: .morning),
            Quote(text: "Give every day the chance to become the most beautiful day of your life.", author: "Mark Twain", period: .morning),
            Quote(text: "The way to get started is to quit talking and begin doing.", author: "Walt Disney", period: .morning),
            Quote(text: "Set your heart on doing good. Do it over and over again, and you will be filled with joy.", author: "Buddha", period: .morning),
            Quote(text: "How wonderful it is that nobody need wait a single moment before starting to improve the world.", author: "Anne Frank", period: .morning),
            Quote(text: "Opportunities are like sunrises. If you wait too long, you miss them.", author: "William Arthur Ward", period: .morning),
            Quote(text: "I arise in the morning torn between a desire to improve the world and a desire to enjoy the world.", author: "E.B. White", period: .morning),
            Quote(text: "The only limit to our realization of tomorrow will be our doubts of today.", author: "Franklin D. Roosevelt", period: .morning),
            Quote(text: "Today I choose life. Every morning when I wake up I can choose joy, happiness, negativity, pain.", author: "Kevyn Aucoin", period: .morning),
            Quote(text: "Write it on your heart that every day is the best day in the year.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "Mindfulness helps you go home to the present. And every time you go there and recognize a condition of happiness that you have, happiness comes.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "The secret of getting ahead is getting started.", author: "Mark Twain", period: .morning),
            Quote(text: "Gratitude makes sense of our past, brings peace for today, and creates a vision for tomorrow.", author: "Melody Beattie", period: .morning),
            Quote(text: "Drink your tea slowly and reverently, as if it is the axis on which the world earth revolves.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Joy is a return to the deep harmony of body, mind and spirit that was yours at birth.", author: "Deepak Chopra", period: .morning),
            Quote(text: "The moment one gives close attention to anything, even a blade of grass, it becomes a mysterious, awesome, indescribably magnificent world in itself.", author: "Henry Miller", period: .morning),
            Quote(text: "Gratitude is the fairest blossom which springs from the soul.", author: "Henry Ward Beecher", period: .morning),
            Quote(text: "When you do things from your soul, you feel a river moving in you, a joy.", author: "Rumi", period: .morning),
            Quote(text: "Act as if what you do makes a difference. It does.", author: "William James", period: .morning),
            Quote(text: "The invariable mark of wisdom is to see the miraculous in the common.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "Whatever you can do, or dream you can, begin it. Boldness has genius, power and magic in it.", author: "Johann Wolfgang von Goethe", period: .morning),
            Quote(text: "If you have good thoughts they will shine out of your face like sunbeams and you will always look lovely.", author: "Roald Dahl", period: .morning),
            Quote(text: "Everything you've ever wanted is on the other side of fear.", author: "George Addair", period: .morning),
            Quote(text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt", period: .morning),
            Quote(text: "The only person you are destined to become is the person you decide to be.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "What we think, we become.", author: "Buddha", period: .morning),
            Quote(text: "Do not let the behavior of others destroy your inner peace.", author: "Dalai Lama", period: .morning),
            Quote(text: "Be gentle with yourself. You are a child of the universe, no less than the trees and the stars.", author: "Max Ehrmann", period: .morning),
            Quote(text: "The greatest glory in living lies not in never falling, but in rising every time we fall.", author: "Nelson Mandela", period: .morning),
            Quote(text: "The purpose of life is not to be happy. It is to be useful, to be honorable, to be compassionate, to have it make some difference that you have lived.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "You are enough just as you are.", author: "Meghan Markle", period: .morning),
            Quote(text: "Happiness is a direction, not a place.", author: "Sydney J. Harris", period: .morning),
            Quote(text: "The privilege of a lifetime is being who you are.", author: "Joseph Campbell", period: .morning),
            Quote(text: "The mind is not a vessel to be filled, but a fire to be kindled.", author: "Plutarch", period: .morning),
            Quote(text: "Life isn't about finding yourself. Life is about creating yourself.", author: "George Bernard Shaw", period: .morning),
            Quote(text: "When you have a dream, you've got to grab it and never let go.", author: "Carol Burnett", period: .morning),
            Quote(text: "Nothing is impossible. The word itself says I'm possible.", author: "Audrey Hepburn", period: .morning),
            Quote(text: "The best preparation for tomorrow is doing your best today.", author: "H. Jackson Brown Jr.", period: .morning),
            Quote(text: "Let your hopes, not your hurts, shape your future.", author: "Robert H. Schuller", period: .morning),
            Quote(text: "You have brains in your head. You have feet in your shoes. You can steer yourself any direction you choose.", author: "Dr. Seuss", period: .morning),
            Quote(text: "Make each day your masterpiece.", author: "John Wooden", period: .morning),
            Quote(text: "Do what you can, with what you have, where you are.", author: "Theodore Roosevelt", period: .morning),
            Quote(text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt", period: .morning),
            Quote(text: "In every walk with nature, one receives far more than one seeks.", author: "John Muir", period: .morning),
            Quote(text: "Go confidently in the direction of your dreams. Live the life you have imagined.", author: "Henry David Thoreau", period: .morning),
            Quote(text: "Light tomorrow with today.", author: "Elizabeth Barrett Browning", period: .morning),
            Quote(text: "The sun himself is weak when he first rises, and gathers strength and courage as the day gets on.", author: "Charles Dickens", period: .morning),
            Quote(text: "With the new day comes new strength and new thoughts.", author: "Eleanor Roosevelt", period: .morning),
            Quote(text: "Simplicity, patience, compassion. These three are your greatest treasures.", author: "Lao Tzu", period: .morning),
            Quote(text: "Let the beauty of what you love be what you do.", author: "Rumi", period: .morning),
            Quote(text: "What you do today can improve all your tomorrows.", author: "Ralph Marston", period: .morning),
            Quote(text: "Kindness is a language which the deaf can hear and the blind can see.", author: "Mark Twain", period: .morning),
            Quote(text: "One small positive thought in the morning can change your whole day.", author: "Dalai Lama", period: .morning),
            Quote(text: "The energy of the mind is the essence of life.", author: "Aristotle", period: .morning),
            Quote(text: "Every day may not be good, but there is something good in every day.", author: "Alice Morse Earle", period: .morning),
            
            // MARK: - Day Quotes (60)
            
            Quote(text: "The power of now is the power of presence.", author: "Eckhart Tolle", period: .day),
            Quote(text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", author: "Ralph Waldo Emerson", period: .day),
            Quote(text: "You must do the thing you think you cannot do.", author: "Eleanor Roosevelt", period: .day),
            Quote(text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill", period: .day),
            Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs", period: .day),
            Quote(text: "I am not what happened to me, I am what I choose to become.", author: "Carl Jung", period: .day),
            Quote(text: "Your time is limited, don't waste it living someone else's life.", author: "Steve Jobs", period: .day),
            Quote(text: "Try to be a rainbow in someone's cloud.", author: "Maya Angelou", period: .day),
            Quote(text: "The mind is its own place, and in itself can make a heaven of hell, a hell of heaven.", author: "John Milton", period: .day),
            Quote(text: "Knowing yourself is the beginning of all wisdom.", author: "Aristotle", period: .day),
            Quote(text: "The only true wisdom is in knowing you know nothing.", author: "Socrates", period: .day),
            Quote(text: "It is not length of life, but depth of life.", author: "Ralph Waldo Emerson", period: .day),
            Quote(text: "Everything has beauty, but not everyone sees it.", author: "Confucius", period: .day),
            Quote(text: "A journey of a thousand miles begins with a single step.", author: "Lao Tzu", period: .day),
            Quote(text: "Be yourself; everyone else is already taken.", author: "Oscar Wilde", period: .day),
            Quote(text: "Stay close to anything that makes you glad you are alive.", author: "Hafiz", period: .day),
            Quote(text: "Not all those who wander are lost.", author: "J.R.R. Tolkien", period: .day),
            Quote(text: "One can never consent to creep when one feels an impulse to soar.", author: "Helen Keller", period: .day),
            Quote(text: "No act of kindness, no matter how small, is ever wasted.", author: "Aesop", period: .day),
            Quote(text: "Silence is a source of great strength.", author: "Lao Tzu", period: .day),
            Quote(text: "Stop acting so small. You are the universe in ecstatic motion.", author: "Rumi", period: .day),
            Quote(text: "Turn your wounds into wisdom.", author: "Oprah Winfrey", period: .day),
            Quote(text: "The only impossible journey is the one you never begin.", author: "Tony Robbins", period: .day),
            Quote(text: "Strive not to be a success, but rather to be of value.", author: "Albert Einstein", period: .day),
            Quote(text: "In the middle of every difficulty lies opportunity.", author: "Albert Einstein", period: .day),
            Quote(text: "We know what we are, but know not what we may be.", author: "William Shakespeare", period: .day),
            Quote(text: "It is during our darkest moments that we must focus to see the light.", author: "Aristotle", period: .day),
            Quote(text: "Everything in moderation, including moderation.", author: "Oscar Wilde", period: .day),
            Quote(text: "Life is really simple, but we insist on making it complicated.", author: "Confucius", period: .day),
            Quote(text: "The unexamined life is not worth living.", author: "Socrates", period: .day),
            Quote(text: "He who has a why to live can bear almost any how.", author: "Friedrich Nietzsche", period: .day),
            Quote(text: "Happiness depends upon ourselves.", author: "Aristotle", period: .day),
            Quote(text: "To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.", author: "Ralph Waldo Emerson", period: .day),
            Quote(text: "Where there is love there is life.", author: "Mahatma Gandhi", period: .day),
            Quote(text: "Speak only if it improves upon the silence.", author: "Mahatma Gandhi", period: .day),
            Quote(text: "The measure of who we are is what we do with what we have.", author: "Vince Lombardi", period: .day),
            Quote(text: "Don't count the days, make the days count.", author: "Muhammad Ali", period: .day),
            Quote(text: "Life is what happens when you're busy making other plans.", author: "John Lennon", period: .day),
            Quote(text: "We are what we repeatedly do. Excellence, then, is not an act, but a habit.", author: "Aristotle", period: .day),
            Quote(text: "The best and most beautiful things in the world cannot be seen or even touched. They must be felt with the heart.", author: "Helen Keller", period: .day),
            Quote(text: "Be kind, for everyone you meet is fighting a hard battle.", author: "Plato", period: .day),
            Quote(text: "Keep your face always toward the sunshine and shadows will fall behind you.", author: "Walt Whitman", period: .day),
            Quote(text: "Love is the only force capable of transforming an enemy into a friend.", author: "Martin Luther King Jr.", period: .day),
            Quote(text: "The obstacle is the path.", author: "Zen Proverb", period: .day),
            Quote(text: "Everything you can imagine is real.", author: "Pablo Picasso", period: .day),
            Quote(text: "If you tell the truth, you don't have to remember anything.", author: "Mark Twain", period: .day),
            Quote(text: "Two roads diverged in a wood, and I took the one less traveled by, and that has made all the difference.", author: "Robert Frost", period: .day),
            Quote(text: "Judge a man by his questions rather than by his answers.", author: "Voltaire", period: .day),
            Quote(text: "That which does not kill us makes us stronger.", author: "Friedrich Nietzsche", period: .day),
            Quote(text: "The world breaks everyone, and afterward, many are strong at the broken places.", author: "Ernest Hemingway", period: .day),
            Quote(text: "Well done is better than well said.", author: "Benjamin Franklin", period: .day),
            Quote(text: "We cannot solve our problems with the same thinking we used when we created them.", author: "Albert Einstein", period: .day),
            Quote(text: "Our life is frittered away by detail. Simplify, simplify.", author: "Henry David Thoreau", period: .day),
            Quote(text: "I have not failed. I've just found 10,000 ways that won't work.", author: "Thomas Edison", period: .day),
            Quote(text: "The only thing we have to fear is fear itself.", author: "Franklin D. Roosevelt", period: .day),
            Quote(text: "Without deviation from the norm, progress is not possible.", author: "Frank Zappa", period: .day),
            Quote(text: "The journey is the reward.", author: "Chinese Proverb", period: .day),
            Quote(text: "A smooth sea never made a skilled sailor.", author: "Franklin D. Roosevelt", period: .day),
            Quote(text: "Courage is not the absence of fear, but rather the judgment that something else is more important than fear.", author: "Ambrose Redmoon", period: .day),
            Quote(text: "Knowledge speaks, but wisdom listens.", author: "Jimi Hendrix", period: .day),
            
            // MARK: - Evening Quotes (60)
            
            Quote(text: "At the end of the day, let there be no excuses, no explanations, no regrets.", author: "Steve Maraboli", period: .evening),
            Quote(text: "Reflect upon your present blessings, of which every man has plenty.", author: "Charles Dickens", period: .evening),
            Quote(text: "How beautiful it is to do nothing, and then rest afterward.", author: "Spanish Proverb", period: .evening),
            Quote(text: "Almost everything will work again if you unplug it for a few minutes, including you.", author: "Anne Lamott", period: .evening),
            Quote(text: "Rest is not idleness, and to lie sometimes on the grass on a summer day listening to the murmur of water, or watching the clouds float across the sky, is hardly a waste of time.", author: "John Lubbock", period: .evening),
            Quote(text: "Sunset is still my favorite color, and rainbow is second.", author: "Mattie Stepanek", period: .evening),
            Quote(text: "There is a calmness to a life lived in gratitude, a quiet joy.", author: "Ralph H. Blum", period: .evening),
            Quote(text: "Adopt the pace of nature: her secret is patience.", author: "Ralph Waldo Emerson", period: .evening),
            Quote(text: "The soul would have no rainbow if the eyes had no tears.", author: "Native American Proverb", period: .evening),
            Quote(text: "For every minute you are angry you lose sixty seconds of happiness.", author: "Ralph Waldo Emerson", period: .evening),
            Quote(text: "In all things of nature there is something of the marvelous.", author: "Aristotle", period: .evening),
            Quote(text: "Take rest; a field that has rested gives a bountiful crop.", author: "Ovid", period: .evening),
            Quote(text: "After a day's walk, everything has twice its usual value.", author: "G.M. Trevelyan", period: .evening),
            Quote(text: "It is not how much we have, but how much we enjoy, that makes happiness.", author: "Charles Spurgeon", period: .evening),
            Quote(text: "Let us be grateful to people who make us happy; they are the charming gardeners who make our souls blossom.", author: "Marcel Proust", period: .evening),
            Quote(text: "Don't be pushed around by the fears in your mind. Be led by the dreams in your heart.", author: "Roy T. Bennett", period: .evening),
            Quote(text: "Every sunset is an opportunity to reset.", author: "Richie Norton", period: .evening),
            Quote(text: "The real things haven't changed. It is still best to be honest and truthful.", author: "Laura Ingalls Wilder", period: .evening),
            Quote(text: "Today was good. Today was fun. Tomorrow is another one.", author: "Dr. Seuss", period: .evening),
            Quote(text: "Count your age by friends, not years. Count your life by smiles, not tears.", author: "John Lennon", period: .evening),
            Quote(text: "Every day brings a chance for you to draw in a breath, kick off your shoes, and dance.", author: "Oprah Winfrey", period: .evening),
            Quote(text: "Do not spoil what you have by desiring what you have not.", author: "Epicurus", period: .evening),
            Quote(text: "It is good to have an end to journey toward; but it is the journey that matters, in the end.", author: "Ursula K. Le Guin", period: .evening),
            Quote(text: "No one is useless in this world who lightens the burden of it to anyone else.", author: "Charles Dickens", period: .evening),
            Quote(text: "We are all in the gutter, but some of us are looking at the stars.", author: "Oscar Wilde", period: .evening),
            Quote(text: "The afternoon knows what the morning never suspected.", author: "Robert Frost", period: .evening),
            Quote(text: "Finish each day and be done with it. You have done what you could. Some blunders and absurdities no doubt crept in; forget them as soon as you can.", author: "Ralph Waldo Emerson", period: .evening),
            Quote(text: "Each day provides its own gifts.", author: "Marcus Aurelius", period: .evening),
            Quote(text: "Piglet noticed that even though he had a Very Small Heart, it could hold a rather large amount of Gratitude.", author: "A.A. Milne", period: .evening),
            Quote(text: "Joy is what happens to us when we allow ourselves to recognize how good things really are.", author: "Marianne Williamson", period: .evening),
            Quote(text: "Feeling gratitude and not expressing it is like wrapping a present and not giving it.", author: "William Arthur Ward", period: .evening),
            Quote(text: "When the sun has set, no candle can replace it.", author: "George R.R. Martin", period: .evening),
            Quote(text: "There is peace even in the storm.", author: "Vincent van Gogh", period: .evening),
            Quote(text: "Dwell on the beauty of life. Watch the stars, and see yourself running with them.", author: "Marcus Aurelius", period: .evening),
            Quote(text: "Life's under no obligation to give us what we expect.", author: "Margaret Mitchell", period: .evening),
            Quote(text: "There are far, far better things ahead than any we leave behind.", author: "C.S. Lewis", period: .evening),
            Quote(text: "You can't go back and change the beginning, but you can start where you are and change the ending.", author: "C.S. Lewis", period: .evening),
            Quote(text: "Blessed are the hearts that can bend; they shall never be broken.", author: "Albert Camus", period: .evening),
            Quote(text: "Life is a series of natural and spontaneous changes. Don't resist them; that only creates sorrow.", author: "Lao Tzu", period: .evening),
            Quote(text: "The purpose of our lives is to be happy.", author: "Dalai Lama", period: .evening),
            Quote(text: "Look deep into nature, and then you will understand everything better.", author: "Albert Einstein", period: .evening),
            Quote(text: "The greatest wealth is to live content with little.", author: "Plato", period: .evening),
            Quote(text: "Only in the darkness can you see the stars.", author: "Martin Luther King Jr.", period: .evening),
            Quote(text: "We must let go of the life we have planned, so as to accept the one that is waiting for us.", author: "Joseph Campbell", period: .evening),
            Quote(text: "Patience is bitter, but its fruit is sweet.", author: "Aristotle", period: .evening),
            Quote(text: "The soul becomes dyed with the color of its thoughts.", author: "Marcus Aurelius", period: .evening),
            Quote(text: "Clouds come floating into my life, no longer to carry rain or usher storm, but to add color to my sunset sky.", author: "Rabindranath Tagore", period: .evening),
            Quote(text: "The setting sun is reflected in me.", author: "Rumi", period: .evening),
            Quote(text: "Forever is composed of nows.", author: "Emily Dickinson", period: .evening),
            Quote(text: "What a wonderful life I've had. I only wish I'd realized it sooner.", author: "Colette", period: .evening),
            Quote(text: "The simple things are also the most extraordinary things, and only the wise can see them.", author: "Paulo Coelho", period: .evening),
            Quote(text: "Be thankful for what you have; you'll end up having more.", author: "Oprah Winfrey", period: .evening),
            Quote(text: "He who lives in harmony with himself lives in harmony with the universe.", author: "Marcus Aurelius", period: .evening),
            Quote(text: "The quieter you become, the more you can hear.", author: "Ram Dass", period: .evening),
            Quote(text: "Find ecstasy in life; the mere sense of living is joy enough.", author: "Emily Dickinson", period: .evening),
            Quote(text: "To love and be loved is to feel the sun from both sides.", author: "David Viscott", period: .evening),
            Quote(text: "It is never too late to be what you might have been.", author: "George Eliot", period: .evening),
            Quote(text: "Sunsets are proof that endings can often be beautiful too.", author: "Beau Taplin", period: .evening),
            Quote(text: "Joy is not in things; it is in us.", author: "Richard Wagner", period: .evening),
            Quote(text: "This too shall pass.", author: "Persian Proverb", period: .evening),
            
            // MARK: - Night Quotes (60)
            
            Quote(text: "Night is a world lit by itself.", author: "Antonio Porchia", period: .night),
            Quote(text: "The night is more alive and more richly colored than the day.", author: "Vincent van Gogh", period: .night),
            Quote(text: "I often think that the night is more alive and more richly colored than the day.", author: "Vincent van Gogh", period: .night),
            Quote(text: "The day is done, and the darkness falls from the wings of Night.", author: "Henry Wadsworth Longfellow", period: .night),
            Quote(text: "Each night, when I go to sleep, I die. And the next morning, when I wake up, I am reborn.", author: "Mahatma Gandhi", period: .night),
            Quote(text: "Sleep is the best meditation.", author: "Dalai Lama", period: .night),
            Quote(text: "Night time is really the best time to work. All the ideas are there to be yours because everyone else is asleep.", author: "Catherine O'Hara", period: .night),
            Quote(text: "The moon is a loyal companion. It never leaves. It's always there, watching, steadfast.", author: "Tahereh Mafi", period: .night),
            Quote(text: "What hath night to do with sleep?", author: "John Milton", period: .night),
            Quote(text: "Those who dream by day are cognizant of many things which escape those who dream only by night.", author: "Edgar Allan Poe", period: .night),
            Quote(text: "The universe is full of magical things patiently waiting for our wits to grow sharper.", author: "Eden Phillpotts", period: .night),
            Quote(text: "I have loved the stars too fondly to be fearful of the night.", author: "Sarah Williams", period: .night),
            Quote(text: "There is something haunting in the light of the moon.", author: "Joseph Conrad", period: .night),
            Quote(text: "The moon will guide you through the night with her brightness, but she will always dwell in the darkness, in order to be seen.", author: "Shannon L. Alder", period: .night),
            Quote(text: "Night is the wonderful opportunity to take rest, to forgive, to smile, to get ready for all the battles that you have to fight tomorrow.", author: "Allen Ginsberg", period: .night),
            Quote(text: "In the depth of winter, I finally learned that within me there lay an invincible summer.", author: "Albert Camus", period: .night),
            Quote(text: "A dreamer is one who can only find his way by moonlight, and his punishment is that he sees the dawn before the rest of the world.", author: "Oscar Wilde", period: .night),
            Quote(text: "There is no sunrise so beautiful that it is worth waking me up to see it.", author: "Mindy Kaling", period: .night),
            Quote(text: "How did it get so late so soon?", author: "Dr. Seuss", period: .night),
            Quote(text: "I like the night. Without the dark, we'd never see the stars.", author: "Stephenie Meyer", period: .night),
            Quote(text: "The darker the night, the brighter the stars.", author: "Fyodor Dostoevsky", period: .night),
            Quote(text: "Look up at the stars and not down at your feet.", author: "Stephen Hawking", period: .night),
            Quote(text: "For my part I know nothing with any certainty, but the sight of the stars makes me dream.", author: "Vincent van Gogh", period: .night),
            Quote(text: "We are all of us stars, and we deserve to twinkle.", author: "Marilyn Monroe", period: .night),
            Quote(text: "The night sky is a miracle of infinitude.", author: "Avijeet Das", period: .night),
            Quote(text: "Midnight is another planet.", author: "David Brin", period: .night),
            Quote(text: "The moon is friend for the lonesome to talk to.", author: "Carl Sandburg", period: .night),
            Quote(text: "Nighttime is the best time to work. All the ideas are there to be yours.", author: "Catherine O'Hara", period: .night),
            Quote(text: "All that we see or seem is but a dream within a dream.", author: "Edgar Allan Poe", period: .night),
            Quote(text: "The soul that sees beauty may sometimes walk alone.", author: "Johann Wolfgang von Goethe", period: .night),
            Quote(text: "Hope is a waking dream.", author: "Aristotle", period: .night),
            Quote(text: "Dreams are the touchstones of our character.", author: "Henry David Thoreau", period: .night),
            Quote(text: "We are such stuff as dreams are made on, and our little life is rounded with a sleep.", author: "William Shakespeare", period: .night),
            Quote(text: "The night is the hardest time to be alive and four a.m. knows all my secrets.", author: "Poppy Z. Brite", period: .night),
            Quote(text: "The world is a dream, you say, and it's lovely, sometimes.", author: "Mary Oliver", period: .night),
            Quote(text: "Dream no small dreams for they have no power to move the hearts of men.", author: "Johann Wolfgang von Goethe", period: .night),
            Quote(text: "Trust the wait. Embrace the uncertainty. Enjoy the beauty of becoming.", author: "Mandy Hale", period: .night),
            Quote(text: "Keep your eyes on the stars, and your feet on the ground.", author: "Theodore Roosevelt", period: .night),
            Quote(text: "The best bridge between despair and hope is a good night's sleep.", author: "E. Joseph Cossman", period: .night),
            Quote(text: "Night brings our troubles to the light, rather than banishes them.", author: "Seneca", period: .night),
            Quote(text: "When it is dark enough, you can see the stars.", author: "Ralph Waldo Emerson", period: .night),
            Quote(text: "Silence is the language of God, all else is poor translation.", author: "Rumi", period: .night),
            Quote(text: "Darkness cannot drive out darkness; only light can do that.", author: "Martin Luther King Jr.", period: .night),
            Quote(text: "The cosmos is within us. We are made of star-stuff.", author: "Carl Sagan", period: .night),
            Quote(text: "There are nights when the wolves are silent and only the moon howls.", author: "George Carlin", period: .night),
            Quote(text: "Night is longer than day for those who dream, and day is longer than night for those who make their dreams come true.", author: "Jack Kerouac", period: .night),
            Quote(text: "Even the darkest night will end and the sun will rise.", author: "Victor Hugo", period: .night),
            Quote(text: "With freedom, books, flowers, and the moon, who could not be happy?", author: "Oscar Wilde", period: .night),
            Quote(text: "There is a time for many words, and there is also a time for sleep.", author: "Homer", period: .night),
            Quote(text: "Listen to the mustn'ts, child. Listen to the don'ts. Listen to the shouldn'ts, the impossibles, the won'ts. Then listen close to me—anything can happen, child. Anything can be.", author: "Shel Silverstein", period: .night),
            Quote(text: "True silence is the rest of the mind, and is to the spirit what sleep is to the body, nourishment and refreshment.", author: "William Penn", period: .night),
            Quote(text: "Let your soul stand cool and composed before a million universes.", author: "Walt Whitman", period: .night),
            Quote(text: "Peace begins when expectation ends.", author: "Sri Chinmoy", period: .night),
            Quote(text: "The noblest pleasure is the joy of understanding.", author: "Leonardo da Vinci", period: .night),
            Quote(text: "What we see depends mainly on what we look for.", author: "John Lubbock", period: .night),
            Quote(text: "Thousands of candles can be lighted from a single candle. Happiness never decreases by being shared.", author: "Buddha", period: .night),
            Quote(text: "Where there is ruin, there is hope for a treasure.", author: "Rumi", period: .night),
            Quote(text: "The nitrogen in our DNA, the calcium in our teeth, the iron in our blood, the carbon in our apple pies were made in the interiors of collapsing stars.", author: "Carl Sagan", period: .night),
            Quote(text: "Tomorrow is always fresh, with no mistakes in it yet.", author: "L.M. Montgomery", period: .night),
            Quote(text: "A well-spent day brings happy sleep.", author: "Leonardo da Vinci", period: .night),
        ]
    }
}
