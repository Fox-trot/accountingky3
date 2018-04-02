﻿
#Область ПеременныеФормы

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//	Кнопки и параметры 
	
	Если Параметры.Свойство("Период")
		И Параметры.Период <> Неопределено Тогда
			
			Переключатель = Параметры.Период;
			НачалоПериода = Параметры["НачалоПериода"];
			КонецПериода  = Параметры["КонецПериода"];
			
	Иначе
		
		Переключатель = "Год";
		НачалоПериода = НачалоГода(ТекущаяДата());
		КонецПериода  = КонецГода(ТекущаяДата());
		
	КонецЕсли;
	
	Элементы.ТаблицаОрганизаций.Доступность = ТолькоВыбранныеОрганизации;
	
	ПроведеноДокументов = 0;
	НеУдалосьПровести   = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьНадписьПериода();
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТолькоВыбранныеОрганизацииПриИзменении(Элемент)
	
	Элементы.ТаблицаОрганизаций.Доступность = ТолькоВыбранныеОрганизации;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательПриИзменении(Элемент)
	
	УстановитьПериод(Переключатель, 0);
	УстановитьНадписьПериода();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УвеличитьПериод(Команда)
	
	УстановитьПериод(Переключатель, 1);
	УстановитьНадписьПериода();
	
КонецПроцедуры // УвеличитьПериод()

&НаКлиенте
Процедура УменьшитьПериод(Команда)
	
	УстановитьПериод(Переключатель, -1);
	УстановитьНадписьПериода();
	
КонецПроцедуры //УменьшитьПериод()

&НаКлиенте
Процедура КнопкаВыполнить(Команда)
	
	ОчиститьСообщения();
	
	Если ТолькоВыбранныеОрганизации = 1 И НЕ ЗначениеЗаполнено(ТаблицаОрганизаций) Тогда
		ТекстСообщения = НСтр("ru = 'Не корректно заполнен список организаций.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ИнициализацияКомандДокументаНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеВнешнимВидомФормы

// Процедура устанавливает параметры компоновки данных и надпись периода на форме
// по полученным параметрам
//
// Изменяемые параметры компоновки данных:
// Начало периода - дата, начала периода формирования отчета
// Конец периода - дата, окончания периода формирования отчета
//
&НаСервере
Процедура УстановитьПериод(НазваниеПериода, Направление)
	
	ЗначениеНачалаПериода 		= НачалоДня(ТекущаяДата());
	ЗначениеОкончанияПериода	= КонецДня(ТекущаяДата());
	
	Если НазваниеПериода = "Неделя" Тогда
		
		КонецПериода = ?(КонецПериода = Дата(1,1,1), ТекущаяДата(), КонецПериода);
		
		ЗначениеНачалаПериода 		= НачалоНедели(КонецПериода + (86400 * 7 * Направление));
		ЗначениеОкончанияПериода	= КонецНедели(КонецПериода + (86400 * 7 * Направление));
		
	ИначеЕсли НазваниеПериода = "Месяц" Тогда
		
		КонецПериода = ?(КонецПериода = Дата(1,1,1), ТекущаяДата(), КонецПериода);
		
		ЗначениеНачалаПериода 		= НачалоМесяца(ДобавитьМесяц(КонецПериода, (1 * Направление)));
		ЗначениеОкончанияПериода	= КонецМесяца(ДобавитьМесяц(КонецПериода, (1 * Направление)));
		
	ИначеЕсли НазваниеПериода = "Квартал" Тогда
		
		КонецПериода = ?(КонецПериода = Дата(1,1,1), ТекущаяДата(), КонецПериода);
		
		ЗначениеНачалаПериода 		= НачалоКвартала(ДобавитьМесяц(КонецПериода, (3 * Направление)));
		ЗначениеОкончанияПериода	= КонецКвартала(ДобавитьМесяц(КонецПериода, (3 * Направление)));
		
	ИначеЕсли НазваниеПериода = "Год" Тогда
		
		КонецПериода = ?(КонецПериода = Дата(1,1,1), ТекущаяДата(), КонецПериода);
		
		ЗначениеНачалаПериода 		= НачалоГода(ДобавитьМесяц(КонецПериода, (12 * Направление)));
		ЗначениеОкончанияПериода	= КонецГода(ДобавитьМесяц(КонецПериода, (12 * Направление)));
		
	КонецЕсли;
		
	НачалоПериода = ЗначениеНачалаПериода;
	КонецПериода = ЗначениеОкончанияПериода;
	
КонецПроцедуры // УстановитьПериод()

// Процедура формирует и обновляет надпись периода на форме
//
&НаКлиенте
Процедура УстановитьНадписьПериода()
	
	//Если не одна кнопка не включена - произвольный период
	Если Переключатель = "" Тогда
		
		ПредставлениеПериода = "Произвольный период";
		
	ИначеЕсли Месяц(НачалоПериода) = Месяц(КонецПериода) Тогда
		
		ДеньРасписанияНачало = Формат(НачалоПериода, "ДФ=дд");
		ДеньРасписанияОкончание = Формат(КонецПериода, "ДФ=дд");
		МесяцРасписанияОкончание = Формат(КонецПериода, "ДФ=МММ");
		ГодРасписания = Формат(Год(КонецПериода), "ЧГ=0");
		
		ПредставлениеПериода = ДеньРасписанияНачало + " - " + ДеньРасписанияОкончание + " " + МесяцРасписанияОкончание + ", " + ГодРасписания;
		
	Иначе
		
		ДеньРасписанияНачало = Формат(НачалоПериода, "ДФ=дд");
		МесяцРасписанияНачало = Формат(НачалоПериода, "ДФ=МММ");
		ДеньРасписанияОкончание = Формат(КонецПериода, "ДФ=дд");
		МесяцРасписанияОкончание = Формат(КонецПериода, "ДФ=МММ");
		
		Если Год(НачалоПериода) = Год(КонецПериода) Тогда
			ГодРасписания = Формат(Год(КонецПериода), "ЧГ=0");
			ПредставлениеПериода = ДеньРасписанияНачало + " " + МесяцРасписанияНачало + " - " + ДеньРасписанияОкончание + " " + МесяцРасписанияОкончание + ", " + ГодРасписания;
			
		Иначе
			ГодРасписанияНачало = Формат(Год(НачалоПериода), "ЧГ=0");
			ГодРасписанияОкончание = Формат(Год(КонецПериода), "ЧГ=0");
			ПредставлениеПериода = ДеньРасписанияНачало + " " + МесяцРасписанияНачало + " " + ГодРасписанияНачало + " - " + ДеньРасписанияОкончание + " " + МесяцРасписанияОкончание + " " + ГодРасписанияОкончание;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // УстановитьНадписьПериода()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ПоказатьРезультатПерепроведения()
	
	ТекстСообщения = НСтр("ru='Выполнено перепроведение документов:
	| - проведено документов: %1;
	|%2'");
	Если НеУдалосьПровести = 0 Тогда
		ТекстСообщенияОбОбшибках = НСтр("ru=' - ошибок не обнаружено.'");
	Иначе
		ТекстСообщенияОбОбшибках = НСтр("ru=' - не удалось провести документов: %1'");
		ТекстСообщенияОбОбшибках = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщенияОбОбшибках, НеУдалосьПровести);
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСообщения, ПроведеноДокументов, ТекстСообщенияОбОбшибках);
		
	ПоказатьПредупреждение(Неопределено,ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ЗагрузитьПодготовленныеДанныеНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				ПоказатьРезультатПерепроведения();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		Иначе
			// Задание отменено
			ИдентификаторЗадания = Неопределено;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура ИнициализацияКомандДокументаНаКлиенте()
	
	Результат = ВыполнитьНаСервере();
	
	Если Результат = 1 Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Перепроведение уже выполняется. Ожидайте завершения.'"));
		Возврат;
	ИначеЕсли Результат = 2 Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Перепроведение уже выполняется другим пользователем.'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ПоказатьРезультатПерепроведения();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если СтруктураДанных.Свойство("ПроведеноДокументов") Тогда
		ПроведеноДокументов = СтруктураДанных.ПроведеноДокументов;
	КонецЕсли;
	Если СтруктураДанных.Свойство("НеУдалосьПровести") Тогда
		НеУдалосьПровести = СтруктураДанных.НеУдалосьПровести;
	КонецЕсли;
	
    ПоказатьСообщенияПользователю();
	
	ИдентификаторЗадания = Неопределено;
	РазблокироватьДанныеДляРедактирования(, УникальныйИдентификатор);

КонецПроцедуры

&НаСервере
Функция ВыполнитьНаСервере()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) 
		И Не ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
		Возврат 1;
	КонецЕсли;
	
	Если ТолькоВыбранныеОрганизации = 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Попытка
				ЗаблокироватьДанныеДляРедактирования(Выборка.Организация,, УникальныйИдентификатор);
			Исключение
				РазблокироватьДанныеДляРедактирования(, УникальныйИдентификатор);
				Возврат 2;
			КонецПопытки;
		КонецЦикла;
	Иначе
		ВыбранныеОрганизации = Новый Массив;
		Для Каждого ЭлементСпискаОрганизаций Из ТаблицаОрганизаций Цикл
			Если ЗначениеЗаполнено(ЭлементСпискаОрганизаций.Организация) Тогда
				ВыбранныеОрганизации.Добавить(ЭлементСпискаОрганизаций.Организация);
				
				Попытка
					ЗаблокироватьДанныеДляРедактирования(ЭлементСпискаОрганизаций.Организация,, УникальныйИдентификатор);
				Исключение
					РазблокироватьДанныеДляРедактирования(, УникальныйИдентификатор);
					Возврат 2;
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("Организация, НачалоПериода, КонецПериода, ЗаписыватьОшибкиВЖурналРегистрации, ОстанавливатьсяПоОшибке",
		?(ТолькоВыбранныеОрганизации = 0, Неопределено, ВыбранныеОрганизации),
		?(ЗначениеЗаполнено(НачалоПериода), НачалоПериода, Неопределено),
		?(ЗначениеЗаполнено(КонецПериода), КонецПериода, Неопределено),
		Истина,
		Истина);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ГрупповоеПерепроведениеДокументов.ПерепроведениеДокументов(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);

	Иначе
		НаименованиеЗадания = НСтр("ru = 'Групповое перепроведение документов'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.ГрупповоеПерепроведениеДокументов.ПерепроведениеДокументов",
			СтруктураПараметров,
			НаименованиеЗадания);

		АдресХранилища       = Результат.АдресХранилища;
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПоказатьСообщенияПользователю()
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат;
	КонецЕсли;
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		МассивСообщений = ФоновоеЗадание.ПолучитьСообщенияПользователю(Истина);
		Если МассивСообщений <> Неопределено Тогда
			Для Каждого Сообщение Из МассивСообщений Цикл
				Сообщение.ИдентификаторНазначения = УникальныйИдентификатор;
				Сообщение.Сообщить();
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
