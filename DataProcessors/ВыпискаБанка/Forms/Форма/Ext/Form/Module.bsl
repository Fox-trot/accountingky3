﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ПриИзмененииЗначенияОрганизацииНаСервере();
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииНаСервере()
	
	БанковскийСчет = Организация.ОсновнойБанковскийСчет;

	СписокДокументов.Очистить();
	
	ЗаполнитьВыписку();

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода БанковскийСчет.
//
&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	СписокДокументов.Очистить();
	БанковскийСчетПриИзмененииНаСервере();
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаСервере
Процедура БанковскийСчетПриИзмененииНаСервере()	
	
	ВалютаДенежныхСредств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет,"ВалютаДенежныхСредств");
		
	Элементы.ДекорацияВалюты.Заголовок = БанковскийСчет.ВалютаДенежныхСредств;
		
	ЗаполнитьВыписку();                   
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаОплатыНачало.
//
&НаКлиенте
Процедура ДатаОплатыНачалоПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ДатаОплатыНачало) Тогда  
		ДатаОплатыКонец = '00010101';
	КонецЕсли;
	
	Если СписокДокументов.Количество() > 0 Тогда

		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
				
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчищениеТабличнойЧастиСписокДокументов", ЭтотОбъект, Параметры);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);		
	Иначе
		ЗаполнитьВыписку();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаОплатыКонец.
//
&НаКлиенте
Процедура ДатаОплатыКонецПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ДатаОплатыКонец) Тогда  
		Возврат;
	ИначеЕсли ДатаОплатыКонец >= '39990101' Тогда 
		ДатаОплатыКонец = '39990101';
	КонецЕсли;
	
	Если СписокДокументов.Количество() > 0 Тогда

		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
				
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчищениеТабличнойЧастиСписокДокументов", ЭтотОбъект, Параметры);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);		
	Иначе
		ЗаполнитьВыписку();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьСписок(Команда)
	ЗаполнитьПустуюДату();

	Если СписокДокументов.Количество() > 0 Тогда

		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
				
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчищениеТабличнойЧастиСписокДокументов", ЭтотОбъект, Параметры);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);		
	Иначе
		ЗаполнитьВыписку();
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьППВ(Команда)
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("Дата", ДатаОплатыКонец);
	ЗначенияЗаполнения.Вставить("БанковскийСчет", БанковскийСчет);
	ЗначенияЗаполнения.Вставить("ОбъектИсточник", "ОбработкаВыпискаБанка");
	Парам = Новый Структура;
	Парам.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);

	ОткрытьФорму("Документ.ПлатежноеПоручениеВходящее.Форма.ФормаДокумента", Парам, ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПОСДС(Команда)
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("Дата", ДатаОплатыКонец);
	ЗначенияЗаполнения.Вставить("БанковскийСчет", БанковскийСчет);
	ЗначенияЗаполнения.Вставить("ОбъектИсточник", "ОбработкаВыпискаБанка");
	Парам = Новый Структура;
	Парам.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);

	ОткрытьФорму("Документ.ПлатежныйОрдерСписаниеДС.Форма.ФормаДокумента", Парам, ЭтаФорма)
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если ВалютаДенежныхСредств = ВалютаРегламентированногоУчета Тогда		
		Элементы.ОстатокНаНачалоДняСом.Видимость	= Истина;
		Элементы.СуммаПриходИтогоСом.Видимость		= Истина;
		Элементы.СуммаРасходИтогоСом.Видимость		= Истина;		
		Элементы.ОстатокНаКонецДняСом.Видимость  	= Истина;		
		Элементы.ОстатокНаНачалоДняСом.Заголовок	= "Остаток на начало дня, " + ВалютаРегламентированногоУчета;
		Элементы.СуммаПриходИтогоСом.Заголовок		= "Приход, " + ВалютаРегламентированногоУчета;
		Элементы.СуммаРасходИтогоСом.Заголовок		= "Расход, " + ВалютаРегламентированногоУчета;		
		Элементы.ОстатокНаКонецДняСом.Заголовок  	= "Остаток на конец дня, " + ВалютаРегламентированногоУчета;
		
		Элементы.ОстатокНаНачалоДня.Видимость		= Ложь;
		Элементы.СуммаПриходИтого.Видимость			= Ложь;
		Элементы.СуммаРасходИтого.Видимость			= Ложь;		
		Элементы.ОстатокНаКонецДня.Видимость  		= Ложь;
		
		Элементы.СписокДокументовСуммаПриход.Видимость			= Истина; 
		Элементы.СписокДокументовСуммаРасход.Видимость			= Истина;
		Элементы.СписокДокументовСуммаПриход.Заголовок			= "Сумма приход, " + ВалютаРегламентированногоУчета; 
		Элементы.СписокДокументовСуммаРасход.Заголовок			= "Сумма расход, " + ВалютаРегламентированногоУчета;		
		Элементы.СписокДокументовСуммаПриходВалютный.Видимость	= Ложь; 
		Элементы.СписокДокументовСуммаРасходВалютный.Видимость	= Ложь;
	Иначе                                                 		
		Элементы.ОстатокНаНачалоДняСом.Видимость 	= Ложь;
		Элементы.СуммаПриходИтогоСом.Видимость		= Ложь;
		Элементы.СуммаРасходИтогоСом.Видимость		= Ложь;			
		Элементы.ОстатокНаКонецДняСом.Видимость  	= Ложь;
		
		Элементы.ОстатокНаНачалоДня.Видимость		= Истина;
		Элементы.СуммаПриходИтого.Видимость			= Истина;
		Элементы.СуммаРасходИтого.Видимость			= Истина;		
		Элементы.ОстатокНаКонецДня.Видимость  		= Истина;
		Элементы.ОстатокНаНачалоДня.Заголовок		= "Остаток на начало дня, " + ВалютаДенежныхСредств;
		Элементы.СуммаПриходИтого.Заголовок			= "Приход, " + ВалютаДенежныхСредств;
		Элементы.СуммаРасходИтого.Заголовок			= "Расход, " + ВалютаДенежныхСредств;		
		Элементы.ОстатокНаКонецДня.Заголовок  		= "Остаток на конец дня, " + ВалютаДенежныхСредств;		
		
		Элементы.СписокДокументовСуммаПриход.Видимость			= Ложь; 
		Элементы.СписокДокументовСуммаРасход.Видимость			= Ложь;		
		Элементы.СписокДокументовСуммаПриходВалютный.Видимость	= Истина; 
		Элементы.СписокДокументовСуммаРасходВалютный.Видимость	= Истина;
		Элементы.СписокДокументовСуммаПриходВалютный.Заголовок	= "Сумма приход, " + ВалютаДенежныхСредств; 
		Элементы.СписокДокументовСуммаРасходВалютный.Заголовок	= "Сумма расход, " + ВалютаДенежныхСредств;	
	КонецЕсли;
КонецПроцедуры

// Управление формой
//
&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ДатаОбработки = ТекущаяДатаСеанса();
	
	Организация 					= Справочники.Организации.ОрганизацияПоУмолчанию();
	ДатаОплатыНачало 				= НачалоДня(ДатаОбработки);
	ДатаОплатыКонец  				= КонецДня(ДатаОбработки); 	
	ВалютаРегламентированногоУчета	= ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(); 	                                  
	Элементы.Организация.Видимость	= ПолучитьФункциональнуюОпцию("УчетПоНесколькимОрганизациям");
			
	Если ЗначениеЗаполнено(Организация) Тогда
		БанковскийСчет = Организация.ОсновнойБанковскийСчет;	
	КонецЕсли;
	
	ЗаполнитьВыписку();
	
	УстановитьПараметрыВыбораБанковскогоСчета(ЭтаФорма);
	
	ВалютаДенежныхСредств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет,"ВалютаДенежныхСредств");
	
	Если ЗначениеЗаполнено(БанковскийСчет) Тогда
		Элементы.ДекорацияВалюты.Заголовок = БанковскийСчет.ВалютаДенежныхСредств;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораБанковскогоСчета(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	НовыйМассивПараметров = Новый Массив();			
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", Форма.Организация));		
	Элементы.БанковскийСчет.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);	
			
КонецПроцедуры

Процедура ЗаполнитьПустуюДату()

	Если НЕ ЗначениеЗаполнено(ДатаОплатыНачало) И ЗначениеЗаполнено(ДатаОплатыКонец) Тогда
		ДатаОплатыНачало = НачалоДня(ДатаОплатыКонец)	
	ИначеЕсли ЗначениеЗаполнено(ДатаОплатыНачало) И НЕ ЗначениеЗаполнено(ДатаОплатыКонец) Тогда	
		ДатаОплатыКонец = КонецДня(ДатаОплатыНачало)
	ИначеЕсли НЕ ЗначениеЗаполнено(ДатаОплатыНачало) И НЕ ЗначениеЗаполнено(ДатаОплатыКонец) Тогда
		ДатаОбработки = ТекущаяДатаСеанса();
		ДатаОплатыНачало = НачалоДня(ДатаОбработки);
		ДатаОплатыКонец = КонецДня(ДатаОбработки);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОчищениеТабличнойЧастиСписокДокументов(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;	

	СписокДокументов.Очистить();
	
	ЗаполнитьВыписку();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыписку()
	
	//УстановитьДанныеПоРегистраторуНаСервере(Неопределено);
		
	Если Организация.Пустая() ИЛИ БанковскийСчет.Пустая() Тогда		
		ОстатокНаНачалоДня      = 0;
		ОстатокНаНачалоДняСом 	= 0;
		СуммаПриходИтого		= 0;
		СуммаПриходИтогоСом  	= 0;
		СуммаРасходИтого		= 0;
		СуммаРасходИтогоСом		= 0;
		ОстатокНаКонецДня       = 0;
		ОстатокНаКонецДняСом  	= 0;		
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПустуюДату();
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ,
	               |	ВЫБОР
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.РасходныйКассовыйОрдер).ВидОперации
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПриходныйКассовыйОрдер).ВидОперации
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).ВидОперации
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).ВидОперации
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	               |			ТОГДА ""Платежный ордер списание ДС""
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.Конвертация
	               |			ТОГДА ""Конвертация""
	               |		ИНАЧЕ ""ПрочееРазное""
	               |	КОНЕЦ КАК ВидОперации,
	               |	ВЫБОР
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.РасходныйКассовыйОрдер).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	               |				И ХозрасчетныйДвиженияОборотыДтКт.СубконтоДт1 ССЫЛКА Справочник.Контрагенты
	               |			ТОГДА ХозрасчетныйДвиженияОборотыДтКт.СубконтоДт1
	               |		ИНАЧЕ """"
	               |	КОНЕЦ КАК Контрагент,
	               |	СУММА(ЕСТЬNULL(ХозрасчетныйДвиженияОборотыДтКт.СуммаОборот, 0)) КАК СуммаПриход,
	               |	СУММА(ЕСТЬNULL(ХозрасчетныйДвиженияОборотыДтКт.ВалютнаяСуммаОборотДт, 0)) КАК СуммаПриходВалютный,
	               |	СУММА(0) КАК СуммаРасходВалютный,
	               |	СУММА(0) КАК СуммаРасход,
	               |	&БанковскийСчет КАК БанковскийСчет,
	               |	ХозрасчетныйДвиженияОборотыДтКт.СчетКт КАК КорСчет,
	               |	ХозрасчетныйДвиженияОборотыДтКт.Период КАК Период
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&ДатаОплатыНачало, &ДатаОплатыКонец, Регистратор, , ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ДенежныеСредства), , , СубконтоДт1 = &БанковскийСчет) КАК ХозрасчетныйДвиженияОборотыДтКт
	               |ГДЕ
	               |	ХозрасчетныйДвиженияОборотыДтКт.СчетДт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц)
	               |			И ХозрасчетныйДвиженияОборотыДтКт.СчетДт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц)
	               |			И ХозрасчетныйДвиженияОборотыДтКт.СчетКт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц)
	               |			И ХозрасчетныйДвиженияОборотыДтКт.СчетКт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ХозрасчетныйДвиженияОборотыДтКт.Регистратор,
	               |	ХозрасчетныйДвиженияОборотыДтКт.Период,
	               |	ВЫБОР
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.РасходныйКассовыйОрдер).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	               |				И ХозрасчетныйДвиженияОборотыДтКт.СубконтоДт1 ССЫЛКА Справочник.Контрагенты
	               |			ТОГДА ХозрасчетныйДвиженияОборотыДтКт.СубконтоДт1
	               |		ИНАЧЕ """"
	               |	КОНЕЦ,
	               |	ХозрасчетныйДвиженияОборотыДтКт.СчетКт
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ХозрасчетныйДвиженияОборотыДтКт.Регистратор,
	               |	ВЫБОР
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.РасходныйКассовыйОрдер).ВидОперации
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПриходныйКассовыйОрдер).ВидОперации
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).ВидОперации
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).ВидОперации
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	               |			ТОГДА ""Платежный ордер списание ДС""
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.Конвертация
	               |			ТОГДА ""Конвертация""
	               |		ИНАЧЕ ""ПрочееРазное""
	               |	КОНЕЦ,
	               |	ВЫБОР
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.РасходныйКассовыйОрдер).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	               |				И ХозрасчетныйДвиженияОборотыДтКт.СубконтоДт1 ССЫЛКА Справочник.Контрагенты
	               |			ТОГДА ХозрасчетныйДвиженияОборотыДтКт.СубконтоДт1
	               |		ИНАЧЕ """"
	               |	КОНЕЦ,
	               |	СУММА(0),
	               |	СУММА(0),
	               |	СУММА(ЕСТЬNULL(ХозрасчетныйДвиженияОборотыДтКт.ВалютнаяСуммаОборотКт, 0)),
	               |	СУММА(ЕСТЬNULL(ХозрасчетныйДвиженияОборотыДтКт.СуммаОборот, 0)),
	               |	&БанковскийСчет,
	               |	ХозрасчетныйДвиженияОборотыДтКт.СчетДт,
	               |	ХозрасчетныйДвиженияОборотыДтКт.Период
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&ДатаОплатыНачало, &ДатаОплатыКонец, Регистратор, , , , ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ДенежныеСредства), СубконтоКт1 = &БанковскийСчет) КАК ХозрасчетныйДвиженияОборотыДтКт
	               |ГДЕ
	               |	ХозрасчетныйДвиженияОборотыДтКт.СчетДт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц)
	               |			И ХозрасчетныйДвиженияОборотыДтКт.СчетДт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц)
	               |			И ХозрасчетныйДвиженияОборотыДтКт.СчетКт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц)
	               |			И ХозрасчетныйДвиженияОборотыДтКт.СчетКт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ХозрасчетныйДвиженияОборотыДтКт.Регистратор,
	               |	ХозрасчетныйДвиженияОборотыДтКт.Период,
	               |	ВЫБОР
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.РасходныйКассовыйОрдер).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияОборотыДтКт.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).Контрагент
	               |		КОГДА ХозрасчетныйДвиженияОборотыДтКт.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	               |				И ХозрасчетныйДвиженияОборотыДтКт.СубконтоДт1 ССЫЛКА Справочник.Контрагенты
	               |			ТОГДА ХозрасчетныйДвиженияОборотыДтКт.СубконтоДт1
	               |		ИНАЧЕ """"
	               |	КОНЕЦ,
	               |	ХозрасчетныйДвиженияОборотыДтКт.СчетДт
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период
	               |ИТОГИ
	               |	СУММА(СуммаПриход),
	               |	СУММА(СуммаПриходВалютный),
	               |	СУММА(СуммаРасходВалютный),
	               |	СУММА(СуммаРасход)
	               |ПО
	               |	ОБЩИЕ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Счет,
	               |	ХозрасчетныйОстатки.Субконто1,
	               |	ХозрасчетныйОстатки.СуммаОстаток,
	               |	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	               |			&ДатаОплатыНачало,
	               |			,
	               |			,
	               |			Организация = &Организация
	               |				И Субконто1 = &БанковскийСчет) КАК ХозрасчетныйОстатки";
				   
				   				   
	//Запрос = Новый Запрос;
	//
	//ТекстЗапроса = "ВЫБРАТЬ
	//               |	ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ,
	//               |	ВЫБОР
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.РасходныйКассовыйОрдер).ВидОперации
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПриходныйКассовыйОрдер).ВидОперации
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).ВидОперации
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).ВидОперации
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	//               |			ТОГДА ""Платежный ордер списание ДС""
	//               |		ИНАЧЕ ""ПрочееРазное""
	//               |	КОНЕЦ КАК ВидОперации,
	//               |	ВЫБОР
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.РасходныйКассовыйОрдер).Контрагент
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Контрагент
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).Контрагент
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).Контрагент
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	//               |				И ХозрасчетныйДвиженияССубконто.СубконтоДт1 ССЫЛКА Справочник.Контрагенты
	//               |			ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоДт1
	//               |		ИНАЧЕ """"
	//               |	КОНЕЦ КАК Контрагент,
	//               |	СУММА(ВЫБОР
	//               |			КОГДА ХозрасчетныйДвиженияССубконто.СубконтоДт1 = &БанковскийСчет
	//               |				ТОГДА ХозрасчетныйДвиженияССубконто.Сумма
	//               |			ИНАЧЕ 0
	//               |		КОНЕЦ) КАК СуммаПриход,
	//               |	СУММА(ВЫБОР
	//               |			КОГДА ХозрасчетныйДвиженияССубконто.СубконтоДт1 = &БанковскийСчет
	//               |				ТОГДА ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаДт
	//               |			ИНАЧЕ 0
	//               |		КОНЕЦ) КАК СуммаПриходВалютный,
	//               |	СУММА(ВЫБОР
	//               |			КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1 = &БанковскийСчет
	//               |				ТОГДА ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаКт
	//               |			ИНАЧЕ 0
	//               |		КОНЕЦ) КАК СуммаРасходВалютный,
	//               |	СУММА(ВЫБОР
	//               |			КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1 = &БанковскийСчет
	//               |				ТОГДА ХозрасчетныйДвиженияССубконто.Сумма
	//               |			ИНАЧЕ 0
	//               |		КОНЕЦ) КАК СуммаРасход,
	//               |	&БанковскийСчет КАК БанковскийСчет,
	//               |	ВЫБОР
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1 = &БанковскийСчет
	//               |			ТОГДА ХозрасчетныйДвиженияССубконто.СчетДт
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.СубконтоДт1 = &БанковскийСчет
	//               |			ТОГДА ХозрасчетныйДвиженияССубконто.СчетКт
	//               |		ИНАЧЕ NULL
	//               |	КОНЕЦ КАК КорСчет,
	//               |	ХозрасчетныйДвиженияССубконто.Период КАК Период
	//               |ИЗ
	//               |	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
	//               |			&ДатаОплатыНачало,
	//               |			&ДатаОплатыКонец,
	//               |			Активность
	//               |				И Субконто1 = &БанковскийСчет,
	//               |			,
	//               |			) КАК ХозрасчетныйДвиженияССубконто
	//               |
	//               |СГРУППИРОВАТЬ ПО
	//               |	ХозрасчетныйДвиженияССубконто.Регистратор,
	//               |	ВЫБОР
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1 = &БанковскийСчет
	//               |			ТОГДА ХозрасчетныйДвиженияССубконто.СчетДт
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.СубконтоДт1 = &БанковскийСчет
	//               |			ТОГДА ХозрасчетныйДвиженияССубконто.СчетКт
	//               |		ИНАЧЕ NULL
	//               |	КОНЕЦ,
	//               |	ВЫБОР
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.РасходныйКассовыйОрдер).Контрагент
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Контрагент
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПлатежноеПоручениеИсходящее).Контрагент
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	//               |			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПлатежноеПоручениеВходящее).Контрагент
	//               |		КОГДА ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ПлатежныйОрдерСписаниеДС
	//               |				И ХозрасчетныйДвиженияССубконто.СубконтоДт1 ССЫЛКА Справочник.Контрагенты
	//               |			ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоДт1
	//               |		ИНАЧЕ """"
	//               |	КОНЕЦ,
	//               |	ХозрасчетныйДвиженияССубконто.Период
	//               |
	//               |УПОРЯДОЧИТЬ ПО
	//               |	Период
	//               |ИТОГИ
	//               |	СУММА(СуммаПриход),
	//               |	СУММА(СуммаПриходВалютный),
	//               |	СУММА(СуммаРасходВалютный),
	//               |	СУММА(СуммаРасход)
	//               |ПО
	//               |	ОБЩИЕ
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ
	//               |	ХозрасчетныйОстатки.Счет,
	//               |	ХозрасчетныйОстатки.Субконто1,
	//               |	ХозрасчетныйОстатки.СуммаОстаток,
	//               |	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток
	//               |ИЗ
	//               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	//               |			&ДатаОплатыНачало,
	//               |			,
	//               |			,
	//               |			Организация = &Организация
	//               |				И Субконто1 = &БанковскийСчет) КАК ХозрасчетныйОстатки";	


	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("БанковскийСчет", 		БанковскийСчет);
	Запрос.УстановитьПараметр("Валюта", 				БанковскийСчет.ВалютаДенежныхСредств);
	Запрос.УстановитьПараметр("Счет", 					БанковскийСчет.СчетУчета);
	Запрос.УстановитьПараметр("Организация", 			Организация);
    Запрос.УстановитьПараметр("ДатаОплатыКонец",      	КонецДня(ДатаОплатыКонец));
	Запрос.УстановитьПараметр("ДатаОплатыНачало",     	НачалоДня(ДатаОплатыНачало));
	
	МассивВидов = Новый Массив;
	МассивВидов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДенежныеСредства);
	Запрос.УстановитьПараметр("Субконто",		МассивВидов);	                                                                   

	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаОбщиеИтоги = РезультатЗапроса[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаОбщиеИтоги.Следующий();
	
	ВыборкаОстатки = РезультатЗапроса[1].Выбрать();
	ВыборкаОстатки.Следующий();
	
	Если БанковскийСчет.ВалютаДенежныхСредств = ВалютаРегламентированногоУчета Тогда
		ЭтаФорма.СуммаПриходИтогоСом	= ВыборкаОбщиеИтоги.СуммаПриход;
		ЭтаФорма.СуммаРасходИтогоСом	= ВыборкаОбщиеИтоги.СуммаРасход;	
		ЭтаФорма.ОстатокНаНачалоДняСом 	= ВыборкаОстатки.СуммаОстаток;
		ЭтаФорма.ОстатокНаКонецДняСом 	= ЭтаФорма.ОстатокНаНачалоДняСом + ЭтаФорма.СуммаПриходИтогоСом - ЭтаФорма.СуммаРасходИтогоСом;
	Иначе
		ЭтаФорма.СуммаПриходИтого		= ВыборкаОбщиеИтоги.СуммаПриходВалютный;
		ЭтаФорма.СуммаРасходИтого		= ВыборкаОбщиеИтоги.СуммаРасходВалютный;	
		ЭтаФорма.ОстатокНаНачалоДня 	= ВыборкаОстатки.ВалютнаяСуммаОстаток;
		ЭтаФорма.ОстатокНаКонецДня 		= ЭтаФорма.ОстатокНаНачалоДня + ЭтаФорма.СуммаПриходИтого - ЭтаФорма.СуммаРасходИтого;			
	КонецЕсли;
	
	ВыборкаСписокДокументов = ВыборкаОбщиеИтоги.Выбрать();	
	Пока ВыборкаСписокДокументов.Следующий() Цикл

		Строка = СписокДокументов.Добавить();

		Строка.Документ        			= ВыборкаСписокДокументов.Документ;
		Строка.Контрагент      			= ВыборкаСписокДокументов.Контрагент;
		Строка.ВидОперации      		= ВыборкаСписокДокументов.ВидОперации;
		Строка.КорСчет      			= ВыборкаСписокДокументов.КорСчет;
		Строка.СуммаПриход     			= ВыборкаСписокДокументов.СуммаПриход;
		Строка.СуммаРасход     			= ВыборкаСписокДокументов.СуммаРасход;
		Строка.СуммаПриходВалютный		= ВыборкаСписокДокументов.СуммаПриходВалютный;
		Строка.СуммаРасходВалютный		= ВыборкаСписокДокументов.СуммаРасходВалютный;				
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьВыписку()

#КонецОбласти









