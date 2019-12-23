﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаписатьСтатусСозданияРезервнойКопии(СтруктураПараметров) Экспорт

	ЗначениеХранилища = Константы.СтатусСверткиИнформационнойБазы.Получить();
	
	Статус = ЗначениеХранилища.Получить();
	
	ЗаполнитьЗначенияСвойств(Статус, СтруктураПараметров);

	Константы.СтатусСверткиИнформационнойБазы.Установить(Новый ХранилищеЗначения(Статус));

КонецПроцедуры

Процедура ЗавершитьСозданиеРезервнойКопии(Знач РезервнаяКопияСоздана, Знач ИмяАдминистратора, Знач АвтоматическийРежимСвертки, ТекущийЭтапСвертки) Экспорт

	ТекстСообщения = НСтр("ru = 'Завершение создания резервной копии информационной базы из внешнего скрипта.'");
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,ТекстСообщения);
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТекущийЭтапСвертки", ТекущийЭтапСвертки);
	СтруктураПараметров.Вставить("РезервнаяКопияСоздана", РезервнаяКопияСоздана);
	СтруктураПараметров.Вставить("ПоказыватьПриСтарте", Истина);
	ЗаписатьСтатусСозданияРезервнойКопии(СтруктураПараметров);
	
КонецПроцедуры

// Выполняет очистку всех настроек обновления конфигурации.
Процедура СброситьСтатусСверткиИнформационнойБазы() Экспорт
	
	ЗначениеХранилища = Константы.СтатусСверткиИнформационнойБазы.Получить();
	
	Статус = ЗначениеХранилища.Получить();
	
	Статус.ТекущийЭтапСвертки = 0;

	Константы.СтатусСверткиИнформационнойБазы.Установить(Новый ХранилищеЗначения(Статус));
	
КонецПроцедуры

// Возвращает имя события для записи журнала регистрации.
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Свертка информационной базы'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ПолучитьСтруктуруСтатусаСверткиИнформационнойБазы(Объект) Экспорт
	
	ОбновитьДеревоПоМетаданным(Объект);
	
	// Задаем место по-умолчанию для создания резервной копии. Файлы не должны удаляться после перезапуска приложения.
	ИмяКаталогаРезервнойКопииИБ = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогВременныхФайлов());
	
	Статус = Новый Структура;
	Статус.Вставить("СпособыСверткиОбъектовМетаданных", 	Объект.СпособыСверткиОбъектовМетаданных.Выгрузить());
	Статус.Вставить("ПериодСвертки", 						НачалоГода(ТекущаяДатаСеанса()));
	Статус.Вставить("ИмяАдминистратораИБ");
	Статус.Вставить("ПарольАдминистратораИБ");
	Статус.Вставить("ИмяКаталогаРезервнойКопииИБ",			ИмяКаталогаРезервнойКопииИБ);
	Статус.Вставить("ТолькоВыбранныеОрганизации",			Ложь);
	Статус.Вставить("Организации");
	Статус.Вставить("ТекущийЭтапСвертки", 					0);
	Статус.Вставить("ПоказыватьПриСтарте", 					Ложь);
	Статус.Вставить("СоздатьРезервнуюКопию", 				Истина);
	Статус.Вставить("РезервнаяКопияСоздана", 				Ложь);
	Статус.Вставить("АктивизацияДвижений", 					Истина);
	Статус.Вставить("РекомендуемыеПараметры", 				Истина);
	Статус.Вставить("УстановитьДатуЗапретаИзмененияДанных",	Истина);

	Константы.СтатусСверткиИнформационнойБазы.Установить(Новый ХранилищеЗначения(Статус));
	
КонецФункции

Процедура ОбновитьДеревоПоМетаданным(Объект) Экспорт
	
	ВосстановитьРекомендуемыеНастройки = Ложь;
	
	// Определение редакции конфигурации
	ПодстрокиВерсии = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Метаданные.Версия, ".");
	Если ПодстрокиВерсии.Количество() > 1 Тогда
		Если ПодстрокиВерсии[0] = "3" и ПодстрокиВерсии[1] = "1" Тогда
			ВосстановитьРекомендуемыеНастройки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Для Бухгалтерии предприятия, редакция 3 способы обработки регистров заполняются рекомендуемыми параметрами.
	ТаблицаРекомендуемыхНастроек = Новый ТаблицаЗначений;
	ТаблицаРекомендуемыхНастроек.Колонки.Добавить("ТипРегистра");
	ТаблицаРекомендуемыхНастроек.Колонки.Добавить("ИмяРегиста");
	ТаблицаРекомендуемыхНастроек.Колонки.Добавить("СпособСвертки");
	
	Если ВосстановитьРекомендуемыеНастройки Тогда
		
		МакетРекомендуемыеПараметрыСверткиРегистров = Обработки.СверткаИнформационнойБазы.ПолучитьМакет("РекомендуемыеНастройкиРегистровБП30");
		
		Для НомерСтроки = 1 По МакетРекомендуемыеПараметрыСверткиРегистров.ВысотаТаблицы Цикл
			
			НоваяСтрока = ТаблицаРекомендуемыхНастроек.Добавить();
			НоваяСтрока.ТипРегистра = СокрЛП(МакетРекомендуемыеПараметрыСверткиРегистров.Область(НомерСтроки, 1).Текст);
			НоваяСтрока.ИмяРегиста = СокрЛП(МакетРекомендуемыеПараметрыСверткиРегистров.Область(НомерСтроки, 2).Текст);
			НоваяСтрока.СпособСвертки = СокрЛП(МакетРекомендуемыеПараметрыСверткиРегистров.Область(НомерСтроки, 3).Текст);
			
		КонецЦикла;
	КонецЕсли;
	
	Объект.СпособыСверткиОбъектовМетаданных.Очистить();
	
	МассивТиповОбъектовМД = Новый Структура();
	МассивТиповОбъектовМД.Вставить("РегистрБухгалтерии", Метаданные.РегистрыБухгалтерии);
	МассивТиповОбъектовМД.Вставить("РегистрНакопления", Метаданные.РегистрыНакопления);
	МассивТиповОбъектовМД.Вставить("РегистрСведений", Метаданные.РегистрыСведений);
	
	Для Каждого ТипОбъектаМД Из МассивТиповОбъектовМД Цикл
		
		Для Каждого ОбъектМД из ТипОбъектаМД.Значение Цикл
			НоваяСтрокаОбъектМД = Объект.СпособыСверткиОбъектовМетаданных.Добавить();
			НоваяСтрокаОбъектМД.ТипОбъектаМД = ТипОбъектаМД.Ключ;
			НоваяСтрокаОбъектМД.ОбъектМД = ОбъектМД.Имя;
			НоваяСтрокаОбъектМД.ОбъектМДСиноним = ОбъектМД.Синоним;
			
			СуществуетРекомендуемаяНастройка = Ложь;
			
			Если ВосстановитьРекомендуемыеНастройки Тогда
				СтруктураОтбора = Новый Структура;
				СтруктураОтбора.Вставить("ТипРегистра",ТипОбъектаМД.Ключ);
				СтруктураОтбора.Вставить("ИмяРегиста",ОбъектМД.Имя);
				
				НайденныеНастройки = ТаблицаРекомендуемыхНастроек.НайтиСтроки(СтруктураОтбора);
				Если НайденныеНастройки.Количество() > 0 Тогда
					СуществуетРекомендуемаяНастройка = Истина;
					НоваяСтрокаОбъектМД.СпособСвертки = НайденныеНастройки[0].СпособСвертки;
				КонецЕсли;
			КонецЕсли;
			
			Если Не СуществуетРекомендуемаяНастройка Тогда
				НоваяСтрокаОбъектМД.СпособСвертки = ПолучитьСпособСверткиПоУмолчанию(ТипОбъектаМД, ОбъектМД);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция НастройкиСверткиРегистровКорректны(Объект) Экспорт
	
	КорректностьНастроек = Истина;
	
	МассивТиповОбъектовМД = Новый Структура();
	МассивТиповОбъектовМД.Вставить("РегистрБухгалтерии", Метаданные.РегистрыБухгалтерии);
	МассивТиповОбъектовМД.Вставить("РегистрНакопления", Метаданные.РегистрыНакопления);
	МассивТиповОбъектовМД.Вставить("РегистрСведений", Метаданные.РегистрыСведений);
	
	Для Каждого НастройкаСвертки Из Объект.СпособыСверткиОбъектовМетаданных Цикл
		
		Если МассивТиповОбъектовМД[НастройкаСвертки.ТипОбъектаМД].Найти(НастройкаСвертки.ОбъектМД) = Неопределено Тогда
			НастройкаСвертки.УстаревшаяНастройка = Истина;
			КорректностьНастроек = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КорректностьНастроек;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает способ свертки для типа объекта метаданных по умолчанию
//
// Параметры
//  ТипОбъектаМД - элемент соответствия, полученного функцией ПолчитьМассивТиповОбъектовМД() 
//  ОбъектМД - метаданные, для которых нужно получить способ свертки
//
// Возвращаемое значение:
//  Строка - способ свертки для данного объекта
Функция ПолучитьСпособСверткиПоУмолчанию(ТипОбъектаМД, ОбъектМД)
	
	Если ТипОбъектаМД.Ключ = "РегистрСведений" Тогда
		Если ОбъектМД.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			СпособСвертки = "Не сворачивать";
			
		ИначеЕсли (ОбъектМД.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору)
			И (НЕ Метаданные.Документы.ОперацияБух.Движения.Содержит(ОбъектМД)) Тогда
			СпособСвертки = "Не сворачивать";
			
		Иначе
			СпособСвертки = "Свернуть";
			
		КонецЕсли;
		
	ИначеЕсли ТипОбъектаМД.Ключ = "РегистрНакопления" Тогда
		СпособСвертки = "Свернуть";
		
	ИначеЕсли ТипОбъектаМД.Ключ = "РегистрБухгалтерии" Тогда
		СпособСвертки = "Свернуть";
		
	КонецЕсли;
	
	Возврат СпособСвертки;
	
КонецФункции

#КонецОбласти