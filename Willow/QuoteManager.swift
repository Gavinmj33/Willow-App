//
//  QuoteManager.swift
//  Willow
//
//  Created by Matthew Gavin on 12/12/25.
//
import Foundation
import Combine

class QuoteManager: ObservableObject {
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
            // Themes: gentle awakening, gratitude, presence, intention, hope
            
            Quote(text: "Waking up this morning, I smile. Twenty-four brand new hours are before me.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "The present moment is filled with joy and happiness. If you are attentive, you will see it.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Because you are alive, everything is possible.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Smile, breathe and go slowly.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Every morning we are born again. What we do today is what matters most.", author: "Buddha", period: .morning),
            Quote(text: "With the new day comes new strength and new thoughts.", author: "Eleanor Roosevelt", period: .morning),
            Quote(text: "The little things? The little moments? They aren't little.", author: "Jon Kabat-Zinn", period: .morning),
            Quote(text: "The breeze at dawn has secrets to tell you. Don't go back to sleep.", author: "Rumi", period: .morning),
            Quote(text: "Let the beauty of what you love be what you do.", author: "Rumi", period: .morning),
            Quote(text: "When you do things from your soul, you feel a river moving in you, a joy.", author: "Rumi", period: .morning),
            Quote(text: "Start where you are. Use what you have. Do what you can.", author: "Pema Chödrön", period: .morning),
            Quote(text: "You are the sky. Everything else is just the weather.", author: "Pema Chödrön", period: .morning),
            Quote(text: "Each morning we must hold out the chalice of our being to receive, to carry, and to give back.", author: "Dag Hammarskjöld", period: .morning),
            Quote(text: "Today, like every other day, we wake up empty and frightened. Don't open the door to the study and begin reading. Take down a musical instrument.", author: "Rumi", period: .morning),
            Quote(text: "This is a wonderful day. I have never seen this one before.", author: "Maya Angelou", period: .morning),
            Quote(text: "Be where you are, not where you think you should be.", author: "Tara Brach", period: .morning),
            Quote(text: "The real meditation is how you live your life.", author: "Jon Kabat-Zinn", period: .morning),
            Quote(text: "Drink your tea slowly and reverently, as if it is the axis on which the world earth revolves.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Walk as if you are kissing the Earth with your feet.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Wherever you are, be there totally.", author: "Eckhart Tolle", period: .morning),
            Quote(text: "Realize deeply that the present moment is all you ever have.", author: "Eckhart Tolle", period: .morning),
            Quote(text: "In today's rush, we all think too much, seek too much, want too much. And forget about the joy of just being.", author: "Eckhart Tolle", period: .morning),
            Quote(text: "Happiness is your nature. It is not wrong to desire it. What is wrong is seeking it outside when it is inside.", author: "Ramana Maharshi", period: .morning),
            Quote(text: "The quieter you become, the more you can hear.", author: "Ram Dass", period: .morning),
            Quote(text: "With self-compassion, we give ourselves the same kindness and care we'd give to a good friend.", author: "Kristin Neff", period: .morning),
            Quote(text: "If you want others to be happy, practice compassion. If you want to be happy, practice compassion.", author: "Dalai Lama", period: .morning),
            Quote(text: "Every day, think as you wake up: today I am fortunate to be alive, I have a precious human life, I am not going to waste it.", author: "Dalai Lama", period: .morning),
            Quote(text: "Simplicity, patience, compassion. These three are your greatest treasures.", author: "Lao Tzu", period: .morning),
            Quote(text: "Nature does not hurry, yet everything is accomplished.", author: "Lao Tzu", period: .morning),
            Quote(text: "A journey of a thousand miles begins with a single step.", author: "Lao Tzu", period: .morning),
            Quote(text: "Hello, sun in my face. Hello you who made the morning and spread it over the fields.", author: "Mary Oliver", period: .morning),
            Quote(text: "Instructions for living a life: Pay attention. Be astonished. Tell about it.", author: "Mary Oliver", period: .morning),
            Quote(text: "It is a serious thing just to be alive on this fresh morning in this broken world.", author: "Mary Oliver", period: .morning),
            Quote(text: "You do not have to be good. You only have to let the soft animal of your body love what it loves.", author: "Mary Oliver", period: .morning),
            Quote(text: "Loving-kindness is the practice of offering care and goodwill to ourselves and others.", author: "Sharon Salzberg", period: .morning),
            Quote(text: "You yourself, as much as anybody in the entire universe, deserve your love and affection.", author: "Sharon Salzberg", period: .morning),
            Quote(text: "Each morning we are born again. What we do today matters most.", author: "Jack Kornfield", period: .morning),
            Quote(text: "In the end, just three things matter: How well we have lived. How well we have loved. How well we have learned to let go.", author: "Jack Kornfield", period: .morning),
            Quote(text: "The heart is like a garden. It can grow compassion or fear, resentment or love.", author: "Jack Kornfield", period: .morning),
            Quote(text: "In every walk with nature, one receives far more than one seeks.", author: "John Muir", period: .morning),
            Quote(text: "The mind takes its shape from what it rests upon.", author: "Rick Hanson", period: .morning),
            Quote(text: "An early-morning walk is a blessing for the whole day.", author: "Henry David Thoreau", period: .morning),
            Quote(text: "The mind is not just brain activity. The mind is a relational and embodied process that regulates the flow of energy and information.", author: "Dan Siegel", period: .morning),
            Quote(text: "Anxiety is the price we pay for being human. It is not a disease to be cured but a signal to be heeded.", author: "Harriet Lerner", period: .morning),
            Quote(text: "Nothing can bring you peace but yourself.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "Write it on your heart that every day is the best day in the year.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "The invariable mark of wisdom is to see the miraculous in the common.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "Adopt the pace of nature: her secret is patience.", author: "Ralph Waldo Emerson", period: .morning),
            Quote(text: "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.", author: "Buddha", period: .morning),
            Quote(text: "Peace comes from within. Do not seek it without.", author: "Buddha", period: .morning),
            Quote(text: "The mind is everything. What you think you become.", author: "Buddha", period: .morning),
            Quote(text: "There is no path to happiness: happiness is the path.", author: "Buddha", period: .morning),
            Quote(text: "Have good trust in yourself, not in the one that you think you should be, but in the one that you are.", author: "Taizan Maezumi", period: .morning),
            Quote(text: "Life is available only in the present moment.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "The way you start your day can affect your whole day. Begin it with a smile.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "To be beautiful means to be yourself. You don't need to be accepted by others. You need to accept yourself.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "The seed of suffering in you may be strong, but don't wait until you have no more suffering before allowing yourself to be happy.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Breathing in, I calm my body. Breathing out, I smile.", author: "Thich Nhat Hanh", period: .morning),
            
            // MARK: - Day Quotes (60)
            // Themes: mindfulness, compassion, inner peace, acceptance, presence
            
            Quote(text: "You can't stop the waves, but you can learn to surf.", author: "Jon Kabat-Zinn", period: .day),
            Quote(text: "Mindfulness is a way of befriending ourselves and our experience.", author: "Jon Kabat-Zinn", period: .day),
            Quote(text: "Wherever you go, there you are.", author: "Jon Kabat-Zinn", period: .day),
            Quote(text: "The best way to capture moments is to pay attention. This is how we cultivate mindfulness.", author: "Jon Kabat-Zinn", period: .day),
            Quote(text: "Breath is the bridge which connects life to consciousness.", author: "Thich Nhat Hanh", period: .day),
            Quote(text: "The best way to take care of the future is to take care of the present moment.", author: "Thich Nhat Hanh", period: .day),
            Quote(text: "When we are mindful, deeply in touch with the present moment, our understanding of what is going on deepens.", author: "Thich Nhat Hanh", period: .day),
            Quote(text: "Letting go gives us freedom, and freedom is the only condition for happiness.", author: "Thich Nhat Hanh", period: .day),
            Quote(text: "Many people think excitement is happiness. But when you are excited you are not peaceful. True happiness is based on peace.", author: "Thich Nhat Hanh", period: .day),
            Quote(text: "What you seek is seeking you.", author: "Rumi", period: .day),
            Quote(text: "The wound is the place where the Light enters you.", author: "Rumi", period: .day),
            Quote(text: "Out beyond ideas of wrongdoing and rightdoing, there is a field. I'll meet you there.", author: "Rumi", period: .day),
            Quote(text: "Yesterday I was clever, so I wanted to change the world. Today I am wise, so I am changing myself.", author: "Rumi", period: .day),
            Quote(text: "Raise your words, not your voice. It is rain that grows flowers, not thunder.", author: "Rumi", period: .day),
            Quote(text: "Nothing ever goes away until it has taught us what we need to know.", author: "Pema Chödrön", period: .day),
            Quote(text: "Compassion becomes real when we recognize our shared humanity.", author: "Pema Chödrön", period: .day),
            Quote(text: "Meditation practice isn't about trying to throw ourselves away and become something better. It's about befriending who we are already.", author: "Pema Chödrön", period: .day),
            Quote(text: "Fear is a natural reaction to moving closer to the truth.", author: "Pema Chödrön", period: .day),
            Quote(text: "The most fundamental aggression to ourselves, the most fundamental harm we can do to ourselves, is to remain ignorant by not having the courage to look at ourselves honestly.", author: "Pema Chödrön", period: .day),
            Quote(text: "If your compassion does not include yourself, it is incomplete.", author: "Jack Kornfield", period: .day),
            Quote(text: "The things that matter most in our lives are not fantastic or grand. They are moments when we touch one another.", author: "Jack Kornfield", period: .day),
            Quote(text: "Everything that has a beginning has an ending. Make your peace with that and all will be well.", author: "Jack Kornfield", period: .day),
            Quote(text: "To pay attention, this is our endless and proper work.", author: "Mary Oliver", period: .day),
            Quote(text: "Still, what I want in my life is to be willing to be dazzled.", author: "Mary Oliver", period: .day),
            Quote(text: "Love yourself. Then forget it. Then, love the world.", author: "Mary Oliver", period: .day),
            Quote(text: "Awareness is the greatest agent for change.", author: "Eckhart Tolle", period: .day),
            Quote(text: "The primary cause of unhappiness is never the situation but your thoughts about it.", author: "Eckhart Tolle", period: .day),
            Quote(text: "Life is the dancer and you are the dance.", author: "Eckhart Tolle", period: .day),
            Quote(text: "Give yourself permission to rest. You are not required to constantly produce to be worthy.", author: "Tara Brach", period: .day),
            Quote(text: "Radical acceptance is the willingness to experience ourselves and our life as it is.", author: "Tara Brach", period: .day),
            Quote(text: "We are not our feelings. We are the awareness that notices them.", author: "Tara Brach", period: .day),
            Quote(text: "The only way to live is by accepting each minute as an unrepeatable miracle.", author: "Tara Brach", period: .day),
            Quote(text: "Mindfulness is simply being aware of what is happening right now without wishing it were different.", author: "James Baraz", period: .day),
            Quote(text: "Silence is a source of great strength.", author: "Lao Tzu", period: .day),
            Quote(text: "When I let go of what I am, I become what I might be.", author: "Lao Tzu", period: .day),
            Quote(text: "When you realize nothing is lacking, the whole world belongs to you.", author: "Lao Tzu", period: .day),
            Quote(text: "If you are depressed you are living in the past. If you are anxious you are living in the future. If you are at peace you are living in the present.", author: "Lao Tzu", period: .day),
            Quote(text: "Be content with what you have; rejoice in the way things are. When you realize there is nothing lacking, the whole world belongs to you.", author: "Lao Tzu", period: .day),
            Quote(text: "Knowing others is intelligence; knowing yourself is true wisdom. Mastering others is strength; mastering yourself is true power.", author: "Lao Tzu", period: .day),
            Quote(text: "The heart that gives, gathers.", author: "Tao Te Ching", period: .day),
            Quote(text: "We are shaped by our thoughts; we become what we think. When the mind is pure, joy follows like a shadow that never leaves.", author: "Buddha", period: .day),
            Quote(text: "In the end, only three things matter: how much you loved, how gently you lived, and how gracefully you let go of things not meant for you.", author: "Buddha", period: .day),
            Quote(text: "Happiness does not depend on what you have or who you are. It solely relies on what you think.", author: "Buddha", period: .day),
            Quote(text: "Being able to feel safe with other people is probably the single most important aspect of mental health.", author: "Bessel van der Kolk", period: .day),
            Quote(text: "The soul always knows what to do to heal itself. The challenge is to silence the mind.", author: "Caroline Myss", period: .day),
            Quote(text: "Within you there is a stillness and a sanctuary to which you can retreat at any time.", author: "Hermann Hesse", period: .day),
            Quote(text: "The act of revealing oneself fully to another and still being accepted may be the major vehicle of therapeutic help.", author: "Irvin Yalom", period: .day),
            Quote(text: "Discomfort is the price of admission to a meaningful life.", author: "Susan David", period: .day),
            Quote(text: "Between stimulus and response there is a space. In that space is our power to choose our response.", author: "Viktor Frankl", period: .day),
            Quote(text: "Everything can be taken from a man but one thing: the last of the human freedoms—to choose one's attitude in any given set of circumstances.", author: "Viktor Frankl", period: .day),
            Quote(text: "The curious paradox is that when I accept myself just as I am, then I can change.", author: "Carl Rogers", period: .day),
            Quote(text: "Be patient toward all that is unsolved in your heart.", author: "Rainer Maria Rilke", period: .day),
            Quote(text: "Let everything happen to you: beauty and terror. Just keep going. No feeling is final.", author: "Rainer Maria Rilke", period: .day),
            Quote(text: "Almost everything will work again if you unplug it for a few minutes, including you.", author: "Anne Lamott", period: .day),
            Quote(text: "Happiness is not something ready made. It comes from your own actions.", author: "Dalai Lama", period: .day),
            Quote(text: "Be kind whenever possible. It is always possible.", author: "Dalai Lama", period: .day),
            Quote(text: "Our prime purpose in this life is to help others. And if you can't help them, at least don't hurt them.", author: "Dalai Lama", period: .day),
            Quote(text: "My religion is very simple. My religion is kindness.", author: "Dalai Lama", period: .day),
            Quote(text: "We must not allow other people's limited perceptions to define us.", author: "Virginia Satir", period: .day),
            Quote(text: "You don't have to like something to accept it. Acceptance is simply acknowledging what is.", author: "Marsha Linehan", period: .day),
            
            // MARK: - Evening Quotes (60)
            // Themes: letting go, reflection, softening, gratitude, rest
            
            Quote(text: "Sometimes your joy is the source of your smile, but sometimes your smile can be the source of your joy.", author: "Thich Nhat Hanh", period: .evening),
            Quote(text: "Hope is important because it can make the present moment less difficult to bear.", author: "Thich Nhat Hanh", period: .evening),
            Quote(text: "People have a hard time letting go of their suffering. Out of a fear of the unknown, they prefer suffering that is familiar.", author: "Thich Nhat Hanh", period: .evening),
            Quote(text: "At any moment, you have a choice, that either leads you closer to your spirit or further away from it.", author: "Thich Nhat Hanh", period: .evening),
            Quote(text: "No mud, no lotus.", author: "Thich Nhat Hanh", period: .evening),
            Quote(text: "Things falling apart is a kind of testing and also a kind of healing.", author: "Pema Chödrön", period: .evening),
            Quote(text: "We can let the circumstances of our lives harden us so that we become increasingly resentful and afraid, or we can let them soften us.", author: "Pema Chödrön", period: .evening),
            Quote(text: "When we are willing to stay even a moment with uncomfortable energy, we gradually learn not to fear it.", author: "Pema Chödrön", period: .evening),
            Quote(text: "It is healing to know all the ways that you're sneaky, all the ways that you hide out. You can know all of that with some sense of humor and kindness.", author: "Pema Chödrön", period: .evening),
            Quote(text: "Our true nature is like a precious jewel: although it may be temporarily buried in mud, it remains completely brilliant and unaffected.", author: "Pema Chödrön", period: .evening),
            Quote(text: "Someone I loved once gave me a box full of darkness. It took me years to understand that this, too, was a gift.", author: "Mary Oliver", period: .evening),
            Quote(text: "Tell me about despair, yours, and I will tell you mine. Meanwhile the world goes on.", author: "Mary Oliver", period: .evening),
            Quote(text: "Have I experienced happiness with sufficient gratitude? Have I been bold enough?", author: "Mary Oliver", period: .evening),
            Quote(text: "The dark does not destroy the light; it defines it. It's our fear of the dark that casts our joy into the shadows.", author: "Brené Brown", period: .evening),
            Quote(text: "Authenticity is the daily practice of letting go of who we think we're supposed to be and embracing who we are.", author: "Brené Brown", period: .evening),
            Quote(text: "If we can share our story with someone who responds with empathy and understanding, shame can't survive.", author: "Brené Brown", period: .evening),
            Quote(text: "Vulnerability is the birthplace of love, belonging, joy, courage, empathy, and creativity.", author: "Brené Brown", period: .evening),
            Quote(text: "Imperfections are not inadequacies; they are reminders that we're all in this together.", author: "Brené Brown", period: .evening),
            Quote(text: "Wear gratitude like a cloak and it will feed every corner of your life.", author: "Rumi", period: .evening),
            Quote(text: "The art of knowing is knowing what to ignore.", author: "Rumi", period: .evening),
            Quote(text: "Set your life on fire. Seek those who fan your flames.", author: "Rumi", period: .evening),
            Quote(text: "This being human is a guest house. Every morning a new arrival.", author: "Rumi", period: .evening),
            Quote(text: "Be like a tree and let the dead leaves drop.", author: "Rumi", period: .evening),
            Quote(text: "There is a crack in everything. That's how the light gets in.", author: "Leonard Cohen", period: .evening),
            Quote(text: "Let go of the crummy stuff and let in the good.", author: "Rick Hanson", period: .evening),
            Quote(text: "Gratitude turns what we have into enough.", author: "Melody Beattie", period: .evening),
            Quote(text: "We must let go of the life we have planned, so as to accept the one that is waiting for us.", author: "Joseph Campbell", period: .evening),
            Quote(text: "The privilege of a lifetime is to become who you truly are.", author: "Carl Jung", period: .evening),
            Quote(text: "Sometimes letting things go is an act of far greater power than defending or hanging on.", author: "Eckhart Tolle", period: .evening),
            Quote(text: "The less you try to force things, the more powerful you become.", author: "Eckhart Tolle", period: .evening),
            Quote(text: "To offer no resistance to life is to be in a state of grace, ease, and lightness.", author: "Eckhart Tolle", period: .evening),
            Quote(text: "Remember that you are not alone in your suffering, and that all humans experience pain and difficulty.", author: "Kristin Neff", period: .evening),
            Quote(text: "Life is a series of natural and spontaneous changes. Don't resist them; that only creates sorrow.", author: "Lao Tzu", period: .evening),
            Quote(text: "New beginnings are often disguised as painful endings.", author: "Lao Tzu", period: .evening),
            Quote(text: "If you let go a little, you will have a little peace. If you let go a lot, you will have a lot of peace.", author: "Ajahn Chah", period: .evening),
            Quote(text: "Looking for peace is like looking for a turtle with a mustache. You won't be able to find it. But when your heart is ready, peace will come looking for you.", author: "Ajahn Chah", period: .evening),
            Quote(text: "Reflect upon your present blessings, of which every man has plenty.", author: "Charles Dickens", period: .evening),
            Quote(text: "Rest is not idleness, and to lie sometimes on the grass on a summer day listening to the murmur of water, or watching the clouds float across the sky, is hardly a waste of time.", author: "John Lubbock", period: .evening),
            Quote(text: "How beautiful it is to do nothing, and then rest afterward.", author: "Spanish Proverb", period: .evening),
            Quote(text: "Take rest; a field that has rested gives a bountiful crop.", author: "Ovid", period: .evening),
            Quote(text: "Each day provides its own gifts.", author: "Marcus Aurelius", period: .evening),
            Quote(text: "Healing takes courage, and we all have courage, even if we have to dig a little to find it.", author: "Tori Amos", period: .evening),
            Quote(text: "What mental health needs is more sunlight, more candor, and more unashamed conversation.", author: "Glenn Close", period: .evening),
            Quote(text: "Talk to yourself like you would to someone you love.", author: "Brené Brown", period: .evening),
            Quote(text: "Very little is needed to make a happy life; it is all within yourself, in your way of thinking.", author: "Marcus Aurelius", period: .evening),
            Quote(text: "Clouds come floating into my life, no longer to carry rain or usher storm, but to add color to my sunset sky.", author: "Rabindranath Tagore", period: .evening),
            Quote(text: "Let us be grateful to people who make us happy; they are the charming gardeners who make our souls blossom.", author: "Marcel Proust", period: .evening),
            Quote(text: "The purpose of our lives is to be happy.", author: "Dalai Lama", period: .evening),
            Quote(text: "Only in the darkness can you see the stars.", author: "Martin Luther King Jr.", period: .evening),
            Quote(text: "There are far, far better things ahead than any we leave behind.", author: "C.S. Lewis", period: .evening),
            Quote(text: "You can't go back and change the beginning, but you can start where you are and change the ending.", author: "C.S. Lewis", period: .evening),
            Quote(text: "Finish each day and be done with it. You have done what you could. Some blunders and absurdities no doubt crept in; forget them as soon as you can.", author: "Ralph Waldo Emerson", period: .evening),
            Quote(text: "For every minute you are angry you lose sixty seconds of happiness.", author: "Ralph Waldo Emerson", period: .evening),
            Quote(text: "It is not how much we have, but how much we enjoy, that makes happiness.", author: "Charles Spurgeon", period: .evening),
            Quote(text: "There is peace even in the storm.", author: "Vincent van Gogh", period: .evening),
            Quote(text: "When we attune to others we allow our own internal state to shift, to come to resonate with the inner world of another.", author: "Dan Siegel", period: .evening),
            Quote(text: "Ultimately, we are all fellow travelers, walking our own paths but sharing the journey.", author: "Irvin Yalom", period: .evening),
            Quote(text: "Courage is not the absence of fear. Courage is fear walking.", author: "Susan David", period: .evening),
            Quote(text: "This too shall pass.", author: "Persian Proverb", period: .evening),
            Quote(text: "Patience is bitter, but its fruit is sweet.", author: "Aristotle", period: .evening),
            
            // MARK: - Night Quotes (60)
            // Themes: rest, calm, tranquil, contemplative
            
            Quote(text: "Breathing in, I calm body and mind. Breathing out, I smile.", author: "Thich Nhat Hanh", period: .night),
            Quote(text: "Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor.", author: "Thich Nhat Hanh", period: .night),
            Quote(text: "Silence is essential. We need silence just as much as we need air, just as much as plants need light.", author: "Thich Nhat Hanh", period: .night),
            Quote(text: "When we come home to ourselves, we feel the peace and tranquility that we have been seeking.", author: "Thich Nhat Hanh", period: .night),
            Quote(text: "In the stillness of the quiet, if we listen, we can hear the whisper of the heart giving strength to weakness, courage to fear, hope to despair.", author: "Howard Thurman", period: .night),
            Quote(text: "Sleep is the best meditation.", author: "Dalai Lama", period: .night),
            Quote(text: "Calm mind brings inner strength and self-confidence, so that's very important for good health.", author: "Dalai Lama", period: .night),
            Quote(text: "The more tranquil a man becomes, the greater is his success, his influence, his power for good.", author: "James Allen", period: .night),
            Quote(text: "Calmness of mind is one of the beautiful jewels of wisdom.", author: "James Allen", period: .night),
            Quote(text: "Put your thoughts to sleep, do not let them cast a shadow over the moon of your heart. Let go of thinking.", author: "Rumi", period: .night),
            Quote(text: "Let the waters settle and you will see the moon and the stars mirrored in your own being.", author: "Rumi", period: .night),
            Quote(text: "Be still. Stillness reveals the secrets of eternity.", author: "Lao Tzu", period: .night),
            Quote(text: "To the mind that is still, the whole universe surrenders.", author: "Lao Tzu", period: .night),
            Quote(text: "Muddy water, let stand, becomes clear.", author: "Lao Tzu", period: .night),
            Quote(text: "Do you have the patience to wait till your mud settles and the water is clear?", author: "Lao Tzu", period: .night),
            Quote(text: "True silence is the rest of the mind, and is to the spirit what sleep is to the body, nourishment and refreshment.", author: "William Penn", period: .night),
            Quote(text: "Silence is the sleep that nourishes wisdom.", author: "Francis Bacon", period: .night),
            Quote(text: "There is a time for many words, and there is also a time for sleep.", author: "Homer", period: .night),
            Quote(text: "A well-spent day brings happy sleep.", author: "Leonardo da Vinci", period: .night),
            Quote(text: "The best bridge between despair and hope is a good night's sleep.", author: "E. Joseph Cossman", period: .night),
            Quote(text: "Rest when you're weary. Refresh and renew yourself, your body, your mind, your spirit.", author: "Ralph Marston", period: .night),
            Quote(text: "Almost everything will work again if you unplug it for a few minutes, including you.", author: "Anne Lamott", period: .night),
            Quote(text: "Within you there is a stillness and a sanctuary to which you can retreat at any time and be yourself.", author: "Hermann Hesse", period: .night),
            Quote(text: "Learning to let go should be learned before learning to get. Life should be touched, not strangled.", author: "Ray Bradbury", period: .night),
            Quote(text: "Peace begins when expectation ends.", author: "Sri Chinmoy", period: .night),
            Quote(text: "This is a moment of suffering. Suffering is part of life. May I be kind to myself in this moment.", author: "Kristin Neff", period: .night),
            Quote(text: "The greatest weapon against stress is our ability to choose one thought over another.", author: "William James", period: .night),
            Quote(text: "Nothing can bring you peace but yourself.", author: "Ralph Waldo Emerson", period: .night),
            Quote(text: "Finish each day and be done with it. You have done what you could.", author: "Ralph Waldo Emerson", period: .night),
            Quote(text: "The body keeps the score. If we can learn to listen to it, it can guide us toward healing.", author: "Bessel van der Kolk", period: .night),
            Quote(text: "Tension is who you think you should be. Relaxation is who you are.", author: "Chinese Proverb", period: .night),
            Quote(text: "In the midst of movement and chaos, keep stillness inside of you.", author: "Deepak Chopra", period: .night),
            Quote(text: "The time to relax is when you don't have time for it.", author: "Sydney J. Harris", period: .night),
            Quote(text: "Your calm mind is the ultimate weapon against your challenges. So relax.", author: "Bryant McGill", period: .night),
            Quote(text: "Set peace of mind as your highest goal, and organize your life around it.", author: "Brian Tracy", period: .night),
            Quote(text: "The mind is like water. When it's turbulent, it's difficult to see. When it's calm, everything becomes clear.", author: "Prasad Mahes", period: .night),
            Quote(text: "Rest and self-care are so important. When you take time to replenish your spirit, it allows you to serve others from the overflow.", author: "Eleanor Brown", period: .night),
            Quote(text: "How we spend our days is, of course, how we spend our lives.", author: "Annie Dillard", period: .night),
            Quote(text: "Slow down and everything you are chasing will come around and catch you.", author: "John De Paola", period: .night),
            Quote(text: "The quieter you become, the more you can hear.", author: "Ram Dass", period: .night),
            Quote(text: "In the sweetness of friendship let there be laughter, and sharing of pleasures. For in the dew of little things the heart finds its morning and is refreshed.", author: "Kahlil Gibran", period: .night),
            Quote(text: "In stillness the world is restored.", author: "Lao Tzu", period: .night),
            Quote(text: "You don't have to control your thoughts. You just have to stop letting them control you.", author: "Dan Millman", period: .night),
            Quote(text: "Feelings of worth can flourish only in an atmosphere where individual differences are appreciated, mistakes are tolerated, and communication is open.", author: "Virginia Satir", period: .night),
            Quote(text: "Rest is not idleness, and to lie sometimes on the grass on a summer day listening to the murmur of water is hardly a waste of time.", author: "John Lubbock", period: .night),
            Quote(text: "Take rest; a field that has rested gives a bountiful crop.", author: "Ovid", period: .night),
            Quote(text: "Each person deserves a day away in which no problems are confronted, no solutions searched for.", author: "Maya Angelou", period: .night),
            Quote(text: "Give yourself permission to rest. You are not required to constantly produce to be worthy.", author: "Tara Brach", period: .night),
            Quote(text: "Learn to be calm and you will always be happy.", author: "Paramahansa Yogananda", period: .night),
            Quote(text: "When you find peace within yourself, you become the kind of person who can live at peace with others.", author: "Peace Pilgrim", period: .night),
            Quote(text: "The soul always knows what to do to heal itself. The challenge is to silence the mind.", author: "Caroline Myss", period: .night),
            Quote(text: "Serenity is not freedom from the storm, but peace amid the storm.", author: "S.A. Jefferson-Wright", period: .night),
            Quote(text: "Radical acceptance rests on letting go of the illusion of control and a willingness to notice and accept things as they are right now.", author: "Marsha Linehan", period: .night),
            Quote(text: "Sleep comes its little while. Then I wake in the valley of midnight to the first fragrances of spring which is coming, all by itself, no matter what.", author: "Mary Oliver", period: .night),
            Quote(text: "The moon is a loyal companion. It never leaves. It's always there, watching, steadfast.", author: "Tahereh Mafi", period: .night),
            Quote(text: "I have loved the stars too fondly to be fearful of the night.", author: "Sarah Williams", period: .night),
            Quote(text: "We are such stuff as dreams are made on, and our little life is rounded with a sleep.", author: "William Shakespeare", period: .night),
            Quote(text: "Tomorrow is always fresh, with no mistakes in it yet.", author: "L.M. Montgomery", period: .night),
            Quote(text: "The day is done, and the darkness falls from the wings of Night, as a feather is wafted downward from an eagle in his flight.", author: "Henry Wadsworth Longfellow", period: .night),
            Quote(text: "Night is a world lit by itself.", author: "Antonio Porchia", period: .night),
        ]
    }
}
