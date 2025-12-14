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
            // MARK: - Morning Quotes
            Quote(text: "Waking up this morning, I smile. Twenty-four brand new hours are before me.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "It is a serious thing just to be alive on this fresh morning in this broken world.", author: "Mary Oliver", period: .morning),
            Quote(text: "Hello, sun in my face. Hello you who made the morning and spread it over the fields. Watch, now, how I start the day in happiness, in kindness.", author: "Mary Oliver", period: .morning),
            Quote(text: "The present moment is filled with joy and happiness. If you are attentive, you will see it.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Owning our story can be hard but not nearly as difficult as spending our lives running from it.", author: "Brené Brown", period: .morning),
            Quote(text: "Start where you are. Use what you have. Do what you can.", author: "Pema Chödrön", period: .morning),
            Quote(text: "Because you are alive, everything is possible.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "Instructions for living a life: Pay attention. Be astonished. Tell about it.", author: "Mary Oliver", period: .morning),
            Quote(text: "Vulnerability is the birthplace of love, belonging, joy, courage, empathy, and creativity.", author: "Brené Brown", period: .morning),
            Quote(text: "You are the sky. Everything else is just the weather.", author: "Pema Chödrön", period: .morning),
            Quote(text: "Life is available only in the present moment.", author: "Thich Nhat Hanh", period: .morning),
            Quote(text: "You do not have to be good. You only have to let the soft animal of your body love what it loves.", author: "Mary Oliver", period: .morning),
            Quote(text: "Imperfections are not inadequacies; they are reminders that we're all in this together.", author: "Brené Brown", period: .morning),
            Quote(text: "Fear is a natural reaction to moving closer to the truth.", author: "Pema Chödrön", period: .morning),
            Quote(text: "Smile, breathe and go slowly.", author: "Thich Nhat Hanh", period: .morning),
            
            // MARK: - Day Quotes
            Quote(text: "How much we know ourselves is extremely important but how we treat ourselves is the most important.", author: "Brené Brown", period: .day),
            Quote(text: "Nothing ever goes away until it has taught us what we need to know.", author: "Pema Chödrön", period: .day),
            Quote(text: "Breath is the bridge which connects life to consciousness.", author: "Thich Nhat Hanh", period: .day),
            Quote(text: "To pay attention, this is our endless and proper work.", author: "Mary Oliver", period: .day),
            Quote(text: "Vulnerability sounds like truth and feels like courage.", author: "Brené Brown", period: .day),
            Quote(text: "Compassion becomes real when we recognize our shared humanity.", author: "Pema Chödrön", period: .day),
            Quote(text: "The best way to take care of the future is to take care of the present moment.", author: "Thich Nhat Hanh", period: .day),
            Quote(text: "Love yourself. Then forget it. Then, love the world.", author: "Mary Oliver", period: .day),
            Quote(text: "What we know matters but who we are matters more.", author: "Brené Brown", period: .day),
            Quote(text: "Meditation practice isn't about trying to throw ourselves away and become something better. It's about befriending who we are already.", author: "Pema Chödrön", period: .day),
            Quote(text: "When we are mindful, deeply in touch with the present moment, our understanding of what is going on deepens.", author: "Thich Nhat Hanh", period: .day),
            Quote(text: "Still, what I want in my life is to be willing to be dazzled.", author: "Mary Oliver", period: .day),
            Quote(text: "We cannot selectively numb emotions. When we numb the painful emotions, we also numb the positive emotions.", author: "Brené Brown", period: .day),
            Quote(text: "Don't worry about achieving. Don't worry about perfection. Just be there each moment as best you can.", author: "Pema Chödrön", period: .day),
            Quote(text: "Letting go gives us freedom, and freedom is the only condition for happiness.", author: "Thich Nhat Hanh", period: .day),
            
            // MARK: - Evening Quotes
            Quote(text: "The dark does not destroy the light; it defines it. It's our fear of the dark that casts our joy into the shadows.", author: "Brené Brown", period: .evening),
            Quote(text: "Things falling apart is a kind of testing and also a kind of healing.", author: "Pema Chödrön", period: .evening),
            Quote(text: "Sometimes your joy is the source of your smile, but sometimes your smile can be the source of your joy.", author: "Thich Nhat Hanh", period: .evening),
            Quote(text: "Someone I loved once gave me a box full of darkness. It took me years to understand that this, too, was a gift.", author: "Mary Oliver", period: .evening),
            Quote(text: "Authenticity is the daily practice of letting go of who we think we're supposed to be and embracing who we are.", author: "Brené Brown", period: .evening),
            Quote(text: "We can let the circumstances of our lives harden us so that we become increasingly resentful and afraid, or we can let them soften us.", author: "Pema Chödrön", period: .evening),
            Quote(text: "Hope is important because it can make the present moment less difficult to bear.", author: "Thich Nhat Hanh", period: .evening),
            Quote(text: "Tell me about despair, yours, and I will tell you mine. Meanwhile the world goes on.", author: "Mary Oliver", period: .evening),
            Quote(text: "If we can share our story with someone who responds with empathy and understanding, shame can't survive.", author: "Brené Brown", period: .evening),
            Quote(text: "When we are willing to stay even a moment with uncomfortable energy, we gradually learn not to fear it.", author: "Pema Chödrön", period: .evening),
            Quote(text: "The seed of suffering in you may be strong, but don't wait until you have no more suffering before allowing yourself to be happy.", author: "Thich Nhat Hanh", period: .evening),
            Quote(text: "Have I experienced happiness with sufficient gratitude? Have I been bold enough?", author: "Mary Oliver", period: .evening),
            Quote(text: "Compassion is not a virtue — it is a commitment.", author: "Brené Brown", period: .evening),
            Quote(text: "It is healing to know all the ways that you're sneaky, all the ways that you hide out. You can know all of that with some sense of humor and kindness.", author: "Pema Chödrön", period: .evening),
            Quote(text: "People have a hard time letting go of their suffering. Out of a fear of the unknown, they prefer suffering that is familiar.", author: "Thich Nhat Hanh", period: .evening),
            
            // MARK: - Night Quotes
            Quote(text: "Sleep comes its little while. Then I wake in the valley of midnight to the first fragrances of spring which is coming, all by itself, no matter what.", author: "Mary Oliver", period: .night),
            Quote(text: "True belonging is the spiritual practice of believing in and belonging to yourself so deeply that you can share your most authentic self with the world.", author: "Brené Brown", period: .night),
            Quote(text: "Our true nature is like a precious jewel: although it may be temporarily buried in mud, it remains completely brilliant and unaffected.", author: "Pema Chödrön", period: .night),
            Quote(text: "Breathing in, I calm body and mind. Breathing out, I smile. Dwelling in the present moment I know this is the only moment.", author: "Thich Nhat Hanh", period: .night),
            Quote(text: "When it's over, I want to say: all my life I was a bride married to amazement.", author: "Mary Oliver", period: .night),
            Quote(text: "Only when we are brave enough to explore the darkness will we discover the infinite power of our light.", author: "Brené Brown", period: .night),
            Quote(text: "Feelings like disappointment, embarrassment, irritation, resentment, anger, jealousy, and fear are actually very clear moments that teach us where we are holding back.", author: "Pema Chödrön", period: .night),
            Quote(text: "Many people think excitement is happiness. But when you are excited you are not peaceful. True happiness is based on peace.", author: "Thich Nhat Hanh", period: .night),
            Quote(text: "The world offers itself to your imagination, calls to you like the wild geese, harsh and exciting—over and over announcing your place in the family of things.", author: "Mary Oliver", period: .night),
            Quote(text: "You are imperfect, you are wired for struggle, but you are worthy of love and belonging.", author: "Brené Brown", period: .night),
            Quote(text: "The most difficult times for many of us are the ones we give ourselves.", author: "Pema Chödrön", period: .night),
            Quote(text: "In order to heal others, we first need to heal ourselves. And to heal ourselves, we need to know how to deal with ourselves.", author: "Thich Nhat Hanh", period: .night),
            Quote(text: "You must not ever stop being whimsical. And you must not, ever, give anyone else the responsibility for your life.", author: "Mary Oliver", period: .night),
            Quote(text: "Courage is like a habit, a virtue: You get it by courageous acts. You learn courage by couraging.", author: "Brené Brown", period: .night),
            Quote(text: "Deep down in the human spirit, there is a reservoir of courage. It is always available, always waiting to be discovered.", author: "Pema Chödrön", period: .night),
        ]
    }
}
