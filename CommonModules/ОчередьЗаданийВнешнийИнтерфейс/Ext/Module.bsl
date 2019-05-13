﻿
#Область ПрограммныйИнтерфейс

// Возвращает описание данных логического хранилища.
//
// Параметры:
//  ИдентификаторХранилища - Строка - идентификатор логического хранилища.
//  ИдентификаторДанных    - Строка - идентификатор данных хранилища.
// 
// Возвращаемое значение:
//   - Структура - описание состояния задания очереди.
//       - ИмяФайла - Строка - имя файла описания состояния задания {УникальныйИдентификатор}.json.
//       - Размер - Число - размер файла в байтах.
//       - Данные - ДвоичныеДанные - двоичные данные файла описания задания.
//
Функция Описание(ИдентификаторХранилища, ИдентификаторДанных) Экспорт
    
    ДвоичныеДанныеОписанияЗадания = ДвоичныеДанныеОписанияЗадания(ИдентификаторДанных);
    Если ДвоичныеДанныеОписанияЗадания = Неопределено Тогда
        СообщениеОбОшибке = ОчередьЗаданийВнешнийИнтерфейсСловарь.ЗаданиеНеНайдено();
        ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИдентификаторДанных);
    КонецЕсли;
    
    Описание = Новый Структура;
    Описание.Вставить("ИмяФайла", ИдентификаторДанных + ".json");
    Описание.Вставить("Размер", ДвоичныеДанныеОписанияЗадания.Размер());
    Описание.Вставить("Данные", ДвоичныеДанныеОписанияЗадания);
    
    Возврат Описание;
	
КонецФункции

// Возвращает данные логического хранилища.
//
// Параметры:
//  ОписаниеДанных - Структура - описание данных хранилища.
// 
// Возвращаемое значение:
//   ДвоичныеДанные - данные из описания данных (см. метод Описание).
//
Функция Данные(ОписаниеДанных) Экспорт
    
	Возврат ОписаниеДанных.Данные;
	
КонецФункции

// МЕТОД НЕ ПОДДЕРЖИВАЕТСЯ. 
// Записывает данные в логическое хранилище.
//
// Возвращаемое значение:
//   - Вызывается исключение.
//
Функция Загрузить(ОписаниеДанных) Экспорт
    
    СообщениеОбОшибке = ОчередьЗаданийВнешнийИнтерфейсСловарь.МетодНеПоддерживается();
    ВызватьИсключение СообщениеОбОшибке;
    
КонецФункции

// Возвращает идентификатор хранилища в виде строки.
// 
// Возвращаемое значение:
//   - Строка - идентификатор хранилища. 
//
Функция ИдентификаторХранилища() Экспорт
	
	Возврат "jobs";
	
КонецФункции
 
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
    
    Типы.Добавить(Метаданные.РегистрыСведений.СвойстваЗаданий);
    
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.0.16.2";
	Обработчик.Процедура = "РегистрыСведений.СвойстваЗаданий.ПеренестиДанныеВФайлы";
	Обработчик.РежимВыполнения = "Оперативно";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.0.16.2";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("d677eb5c-159c-11e8-b642-0ed5f89f718b");
	Обработчик.Процедура = "РегистрыСведений.СвойстваЗаданий.УдалитьНеАктуальныеЗаписи";
	Обработчик.Комментарий = НСтр("ru = 'Очищает не актуальные записи свойств заданий очереди.'");
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.ЧитаемыеОбъекты   = "РегистрыСведений.СвойстваЗаданий";
	Обработчик.ИзменяемыеОбъекты = "РегистрыСведений.СвойстваЗаданий";
	
КонецПроцедуры

// Обработчик подписки на событие ОчередьЗаданийПередУдалением.
//
// Параметры:
//  Источник - СправочникОбъект.ОчередьЗаданий, СправочникОбъект.ОчередьЗаданийОбластейДанных - удаляемый объект.
//  Отказ    - Булево - признак отказа от удаления.
//
Процедура ОчередьЗаданийПередУдалением(Источник, Отказ) Экспорт

    Если Источник.ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;
    
    РегистрыСведений.СвойстваЗаданий.ОчиститьСвойствоЗадание(Источник.Ссылка);
    
КонецПроцедуры

// Обработчик подписки на событие ОчередьЗаданийПриЗаписи.
//
// Параметры:
//  Источник - СправочникОбъект.ОчередьЗаданий, СправочникОбъект.ОчередьЗаданийОбластейДанных - записываемый объект.
//  Отказ    - Булево - признак отказа от записи объекта.
//
Процедура ОчередьЗаданийПриЗаписи(Источник, Отказ) Экспорт
    
    Если Источник.ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;
	
	Словарь = ОчередьЗаданийВнешнийИнтерфейсСловарь;
    
    СвойстваЗадания = РегистрыСведений.СвойстваЗаданий.НовыйСвойстваЗадания();
    Если Источник.СостояниеЗадания = Перечисления.СостоянияЗаданий.Запланировано Или 
        Источник.СостояниеЗадания = Перечисления.СостоянияЗаданий.Выполняется Тогда
        СвойстваЗадания.КодСостояния = Словарь.КодСостоянияОжидание();
        РегистрыСведений.СвойстваЗаданий.Установить(Источник.Ссылка, СвойстваЗадания);
    КонецЕсли; 
    
    Если Источник.ПометкаУдаления Тогда
        РегистрыСведений.СвойстваЗаданий.ОчиститьСвойствоЗадание(Источник.Ссылка);
    КонецЕсли; 
    
КонецПроцедуры

// Устанавливает в свойствах задания состояние ошибки данных.
// Используется при ошибках в логике обработки или при неправильных составах данных для обработки.
//
// Параметры:
//  ИдентификаторЗадания - УниверсальныйИдентификатор - уникальный идентификатор ссылки задания.
//  СообщениеОбОшибке    - Строка - сообщение об ошибке для добавления в свойства задания.
//
Процедура УстановитьОшибкуДанных(ИдентификаторЗадания, СообщениеОбОшибке) Экспорт
	
    Словарь = ОчередьЗаданийВнешнийИнтерфейсСловарь;
    Свойства = РегистрыСведений.СвойстваЗаданий.НовыйСвойстваЗадания();
    Свойства.КодСостояния = Словарь.КодСостоянияОшибкаДанных();
    Свойства.СообщениеОбОшибке = СообщениеОбОшибке;
    РегистрыСведений.СвойстваЗаданий.Установить(ИдентификаторЗадания, Свойства);
	
КонецПроцедуры

// Устанавливает в свойствах задания состояние внутренней ошибки.
//
// Параметры:
//  ИдентификаторЗадания - УниверсальныйИдентификатор - уникальный идентификатор ссылки задания.
//  СообщениеОбОшибке    - Строка - сообщение об ошибке для добавления в свойства задания.
//
Процедура УстановитьВнутреннююОшибку(ИдентификаторЗадания, СообщениеОбОшибке) Экспорт
    
    Словарь = ОчередьЗаданийВнешнийИнтерфейсСловарь;
    Свойства = РегистрыСведений.СвойстваЗаданий.НовыйСвойстваЗадания();
    Свойства.КодСостояния = Словарь.КодСостоянияВнутренняяОшибка();
    Свойства.СообщениеОбОшибке = СообщениеОбОшибке;
    РегистрыСведений.СвойстваЗаданий.Установить(ИдентификаторЗадания, Свойства);
	
КонецПроцедуры

// Возвращает уникальный идентификатор выполняющегося задания по ключу.
//
// Параметры:
//  Ключ - Строка - ключ задания для поиска выполняющегося задания.
// 
// Возвращаемое значение:
//   - 
//
Функция ИдентификаторЗадания(Ключ) Экспорт
    
    Отбор = Новый Структура;
    Отбор.Вставить("Ключ", Ключ);
    Отбор.Вставить("СостояниеЗадания", Перечисления.СостоянияЗаданий.Выполняется);
    ПоискЗаданий = ОчередьЗаданий.ПолучитьЗадания(Отбор);
    Если ПоискЗаданий.Количество() = 0 Тогда
        СообщениеОбОшибке = ОчередьЗаданийВнешнийИнтерфейсСловарь.ЗаданиеПоКлючуНеНайдено();
        ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, Ключ); 
    КонецЕсли;
    
    Возврат ПоискЗаданий[0].Идентификатор.УникальныйИдентификатор();
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеСостоянияЗадания(ИдентификаторЗадания)
    
    Словарь = ОчередьЗаданийВнешнийИнтерфейсСловарь;
    Идентификатор = Новый УникальныйИдентификатор(ИдентификаторЗадания);
    Отбор = Новый Структура("Идентификатор", Идентификатор);
    
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ ПЕРВЫЕ 1
        |   СвойстваЗаданий.КодСостояния КАК КодСостояния,
        |   СвойстваЗаданий.Ошибка КАК Ошибка,
        |   СвойстваЗаданий.ИдентификаторСообщенияОбОшибке КАК ИдентификаторСообщенияОбОшибке,
        |   СвойстваЗаданий.ИдентификаторРезультата КАК ИдентификаторРезультата
        |ИЗ
        |   РегистрСведений.СвойстваЗаданий КАК СвойстваЗаданий
        |ГДЕ
        |   СвойстваЗаданий.ИдентификаторЗадания = &ИдентификаторЗадания";
    Запрос.УстановитьПараметр("ИдентификаторЗадания", Идентификатор);
	УстановитьПривилегированныйРежим(Истина);
    СвойстваЗадания = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
    Если СвойстваЗадания.Пустой() Тогда
        Возврат Неопределено;
    Иначе
        СвойстваЗадания = СвойстваЗадания.Выгрузить()[0];
        Данные = Новый Структура;
        Данные.Вставить(Словарь.ПолеКодСостояния(), СвойстваЗадания.КодСостояния);
        Данные.Вставить(Словарь.ПолеОшибка(), СвойстваЗадания.Ошибка);
        Данные.Вставить(Словарь.ПолеСообщениеОбОшибке(),"");
        Если ЗначениеЗаполнено(СвойстваЗадания.ИдентификаторСообщенияОбОшибке) Тогда
            ДанныеСообщенияОбОшибке = ФайлыОбластейДанных.ДвоичныеДанныеФайла(СвойстваЗадания.ИдентификаторСообщенияОбОшибке);
            СтрокаСообщенияОбОшибке = ПолучитьСтрокуИзДвоичныхДанных(ДанныеСообщенияОбОшибке);
            Данные[Словарь.ПолеСообщениеОбОшибке()] = СтрокаСообщенияОбОшибке;
        КонецЕсли; 
        Описание = НовыйОписаниеСостоянияЗадания();
        ЗаполнитьЗначенияСвойств(Описание[Словарь.ПолеОсновнойРаздел()], Данные);
        Если ЗначениеЗаполнено(СвойстваЗадания.ИдентификаторРезультата) Тогда
            ДанныеРезультата = ФайлыОбластейДанных.ДвоичныеДанныеФайла(СвойстваЗадания.ИдентификаторРезультата);
            СтрокаРезультата = ПолучитьСтрокуИзДвоичныхДанных(ДанныеРезультата);
            Если (Лев(СтрокаРезультата, 1) = "{" И Прав(СтрокаРезультата, 1) = "}") 
             Или (Лев(СтрокаРезультата, 1) = "[" И Прав(СтрокаРезультата, 1) = "]") Тогда
                // Попытаемся превратить результат в структуру, 
                // чтобы потом обратно сериализовать в JSON.
                Попытка
                    ЗначениеРезультата = РаботаВМоделиСервисаБТС.СтруктураИзСтрокиJSON(СтрокаРезультата);
                Исключение
                    // Не удалось десериализовать данные из строки.
                    // В этом случае в результате будет возвращен текст из результата.
                    // Исключение проглатывается запланировано.
                    ЗначениеРезультата = СтрокаРезультата;
                КонецПопытки;
            Иначе
                ЗначениеРезультата = СтрокаРезультата;
            КонецЕсли;
            Описание[Словарь.ПолеРезультат()] = ЗначениеРезультата;
        Иначе
            Описание[Словарь.ПолеРезультат()] = Неопределено;    
        КонецЕсли;
        УдалитьПустойРезультат(Описание);
        Возврат Описание
    КонецЕсли; 
    
КонецФункции

Функция ДвоичныеДанныеОписанияЗадания(ИдентификаторЗадания)
    
    ОписаниеСостояния = ОписаниеСостоянияЗадания(ИдентификаторЗадания);
    Если ОписаниеСостояния = Неопределено Тогда
        Возврат Неопределено;    
    КонецЕсли; 
    ОписаниеСостоянияЗадания = РаботаВМоделиСервисаБТС.СтрокаИзСтруктурыJSON(ОписаниеСостояния);
    ДвоичныеДанныеОписанияЗадания = ПолучитьДвоичныеДанныеИзСтроки(ОписаниеСостоянияЗадания);
    
    Возврат ДвоичныеДанныеОписанияЗадания;
    
КонецФункции    

Функция НовыйОписаниеСостоянияЗадания()

    Словарь = ОчередьЗаданийВнешнийИнтерфейсСловарь;
    ОсновнаяСекция = Новый Структура;
	ОсновнаяСекция.Вставить(Словарь.ПолеКодСостояния(), 0);
	ОсновнаяСекция.Вставить(Словарь.ПолеОшибка(), Ложь);
	ОсновнаяСекция.Вставить(Словарь.ПолеСообщениеОбОшибке(), "");
    
	ОписаниеСостояния = Новый Структура;
    ОписаниеСостояния.Вставить(Словарь.ПолеОсновнойРаздел(), ОсновнаяСекция);
    ОписаниеСостояния.Вставить(Словарь.ПолеРезультат());
	
	Возврат ОписаниеСостояния;

КонецФункции

Процедура УдалитьПустойРезультат(Ответ)
    
    ПолеРезультат = ОчередьЗаданийВнешнийИнтерфейсСловарь.ПолеРезультат();
    Если Ответ.Свойство(ПолеРезультат) И Не ЗначениеЗаполнено(Ответ[ПолеРезультат]) Тогда
        Ответ.Удалить(ПолеРезультат);
    КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 
