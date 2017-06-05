﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ДатаСеанса() Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Возврат ТекущаяДатаСеанса();
	#Иначе
		Возврат ОбщегоНазначенияКлиент.ДатаСеанса();
	#КонецЕсли
	
КонецФункции

// Возвращает Истина, если переданный объект содержит 
// значения по умолчанию для гражданства
//
// Параметры:
//	ИнформацияОГражданстве - объект, имеющий свойства 
//		Страна
//		
Функция ГражданствоПоУмолчанию(ИнформацияОГражданстве) Экспорт
	
	Возврат ИнформацияОГражданстве.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.Киргизия");
	
КонецФункции

// Возвращает Истина, если переданный объект содержит 
// значения по умолчанию для сведений об инвалидности
// т.е. сотрудник не является инвалидом
//
// Параметры:
//	СведенияОбИнвалидности - объект, имеющий свойства 
//		Инвалидность
//		СрокДействияСправки
//		
Функция СведенияОбИнвалидностиПоУмолчанию(СведенияОбИнвалидности) Экспорт
	Возврат (НЕ ЗначениеЗаполнено(СведенияОбИнвалидности.ДатаВыдачи))
		И (НЕ ЗначениеЗаполнено(СведенияОбИнвалидности.СрокДействияСправки))
КонецФункции

// Возвращает Истина, если переданный объект содержит 
// значения по умолчанию для удостоверения личности
//
// Параметры:
//	ИнформацияОбУдостоверенииЛичности - объект, имеющий свойства 
//		ВидДокумента
//		Серия
//		Номер
//		ДатаВыдачи
//		КемВыдан
//		КодПодразделения
//		
Функция УдостоверениеЛичностиПоУмолчанию(ИнформацияОбУдостоверенииЛичности) Экспорт
	
	Возврат (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.ВидДокумента))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.Серия))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.Номер))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.ДатаВыдачи))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.СрокДействия))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.КемВыдан))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.КодПодразделения));
		
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Универсальный механизм "Месяц строкой"

// Заполняет реквизит представлением месяца, хранящегося в другом реквизите
//
// Параметры:
//		РедактируемыйОбъект
//		ПутьРеквизита - Строка, путь к реквизиту, содержащего дату
//		ПутьРеквизитаПредставления - Строка, путь к реквизиту в который помещается представление месяца
//
Процедура ЗаполнитьМесяцПоДате(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления) Экспорт
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, ПолучитьПредставлениеМесяца(Значение));
	
КонецПроцедуры

// Заполняет реквизиты представления месяцев, хранящихся в других реквизитах
//
// Параметры:
//		ДанныеТабличнойЧасти - коллекция строк табличной части
//		ПутьРеквизита - Строка, путь к реквизиту, содержащего дату
//		ПутьРеквизитаПредставления - Строка, путь к реквизиту в который помещается представление месяца
//
Процедура ЗаполнитьМесяцПоДатеВТабличнойЧасти(ДанныеТабличнойЧасти, ПутьРеквизита, ПутьРеквизитаПредставления) Экспорт
	Для Каждого СтрокаТабличнойЧасти Из ДанныеТабличнойЧасти Цикл
		ЗаполнитьМесяцПоДате(СтрокаТабличнойЧасти, ПутьРеквизита, ПутьРеквизитаПредставления);
	КонецЦикла;
КонецПроцедуры

// Возвращает представление месяца по переданной дате
//
// Параметры:
//		ДатаНачалаМесяца
//
// Возвращаемое значение;
//		Строка
//
Функция ПолучитьПредставлениеМесяца(ДатаНачалаМесяца) Экспорт
	
	Возврат Формат(ДатаНачалаМесяца, "ДФ='ММММ гггг'");
	
КонецФункции

// Возвращает представление квартала по переданной дате
//
// Параметры:
//		ДатаНачалаМесяца
//
// Возвращаемое значение;
//		Строка
//
Функция ПолучитьПредставлениеКвартала(ДатаНачалаМесяца) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаНачалаМесяца) Тогда
		Возврат "";
	КонецЕсли;	
	
	Возврат ПредставлениеПериода(ДатаНачалаМесяца, КонецКвартала(ДатаНачалаМесяца), "ФП = Истина");
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Проверка заполнения свойств

// Проверяет заполнение реквизитов переданного объекта по заданным правилам
// 
// Параметры
//	ПроверяемыйОбъект	- проверяемое, любой объект, допускающий доступ к полям по имени
//	ПравилаПроверки		- структура, в которой ключем является проверяемое свойство, 
//						а значением - сообщение об ошибке
//	СообщитьПользователю- признак, выдавать ли сообщение пользователю
//								
//	Возвращаемое значение:
//		Булево. Истина - ошибок не обнаружено, Ложь - в противном случае. 
//			
Функция СвойстваЗаполнены(ПроверяемыйОбъект, ПравилаПроверки, СообщитьПользователю = Ложь) Экспорт
	
	НарушенныеПравила = Новый Массив;
	
	Для Каждого ПравилоПроверки Из ПравилаПроверки Цикл
		Если НЕ ЗначениеЗаполнено(ПроверяемыйОбъект[ПравилоПроверки.Ключ]) Тогда
			НарушенныеПравила.Добавить(ПравилоПроверки);
		КонецЕсли;
	КонецЦикла;
	
	Если СообщитьПользователю Тогда
		Для Каждого НарушенноеПравило Из НарушенныеПравила Цикл 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НарушенноеПравило.Значение, ПроверяемыйОбъект, НарушенноеПравило.Ключ);
		КонецЦикла
	КонецЕсли;
	
	Возврат НарушенныеПравила.Количество() = 0;
	
КонецФункции

// Проверяет заполнение реквизитов переданного объекта по заданным правилам
// 
// Параметры
//	Форма			- управляемая форма
//	ПравилаПроверки	- список значение, в которой значением является путь к данными, 
//						а значением - сообщение об ошибке
//	СообщитьПользователю- признак, выдавать ли сообщение пользователю
//								
//	Возвращаемое значение:
//		Булево. Истина - все свойства заполнены, Ложь - в противном случае. 
//			
Функция СвойстваФормыЗаполнены(Форма, ПравилаПроверки, СообщитьПользователю = Ложь) Экспорт
	
	НарушенныеПравила = Новый Массив;
	
	Для Каждого ПравилоПроверки Из ПравилаПроверки Цикл
		
		Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПравилоПроверки.Значение);
		
		Если НЕ ЗначениеЗаполнено(Значение) Тогда
			НарушенныеПравила.Добавить(ПравилоПроверки);
		КонецЕсли;
	КонецЦикла;
	
	Если СообщитьПользователю Тогда
		Для Каждого НарушенноеПравило Из НарушенныеПравила Цикл 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НарушенноеПравило.Представление, , НарушенноеПравило.Значение);
		КонецЦикла
	КонецЕсли;
	
	Возврат НарушенныеПравила.Количество() = 0;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Математические функции

// Округляет число до заданной точности по указанному правилу.
//
// Параметры:
//  Число                   - число, число которое необходимо округлить
//  Точность        		- число, "базис" до которого нужно округлить заданное число 
//  Правило 				- перечисление "ПравилаОкругленияПриРасчетеЗарплаты"
//
// Возвращаемое значение:
// Число - округленное до заданной точности значение.
//
Функция Округлить(Число, Точность = 0, Правило = Неопределено) Экспорт
	
	// Если надо округлить 0 или точность не задана, то возвращаем заданное число
	Если Не ЗначениеЗаполнено(Число) 
		Или Точность <= 0 Тогда
		Возврат Число
	КонецЕсли;
	
	Множитель  		= Число / Точность;
	ЦелыйМножитель 	= Цел(Множитель);
	
	Если Множитель = ЦелыйМножитель Тогда
		Результат = Число;
	Иначе
		Результат = Точность * Окр(Множитель);
		
		Если Правило = ПредопределенноеЗначение("Перечисление.ПравилаОкругленияПриРасчетеЗарплаты.ВБольшуюСторону") Тогда
			Результат = Точность * (ЦелыйМножитель + 1);
		ИначеЕсли Правило = ПредопределенноеЗначение("Перечисление.ПравилаОкругленияПриРасчетеЗарплаты.ВМеньшуюСторону") Тогда
			Результат = Точность * ЦелыйМножитель;
		КонецЕсли; 
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Расшифровка рег.отчетности

// По переданному имени показателя регламентированного отчета определяет
// раздел отчета, которому принадлежит показатель
// 
// Параметры
//	ИмяПоказателя - Строка
//								
//	Возвращаемое значение:
//		Строка описания (из 2 символов) раздела отчета или Неопределено,  
//		если переданное ИмяПоказателя не имеет ожидаемой структуры.	
//			
Функция РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя) Экспорт
	
	Если ВРег(Лев(ИмяПоказателя,1)) <> "П" Или СтрДлина(ИмяПоказателя) < 13 Тогда
		Возврат Неопределено
	КонецЕсли;	
	
	Возврат Сред(ИмяПоказателя, 5, 2)
	
КонецФункции

// По переданному имени показателя регламентированного отчета определяет
// номер строки таблицы отчета, в которой расположен показатель
// 
// Параметры
//	ИмяПоказателя - Строка
//								
//	Возвращаемое значение:
//		Строка описания (номер из 3 символов) строки таблицы отчета или 
//		Неопределено, если переданное ИмяПоказателя не имеет ожидаемой структуры.	
//			
Функция СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя) Экспорт
	
	Если ВРег(Лев(ИмяПоказателя,1)) <> "П" Или СтрДлина(ИмяПоказателя) < 13 Тогда
		Возврат Неопределено
	КонецЕсли;	
	
	Возврат Сред(ИмяПоказателя, 9, 3)
	
КонецФункции

// По переданному имени показателя регламентированного отчета определяет
// номер колонки таблицы отчета, в которой расположен показатель
// 
// Параметры
//	ИмяПоказателя - Строка
//								
//	Возвращаемое значение:
//		Строка описания (номер из 2 символов) колонки таблицы отчета или  
//		Неопределено, если переданное ИмяПоказателя не имеет ожидаемой структуры.	
//			
Функция КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя) Экспорт
	
	Если ВРег(Лев(ИмяПоказателя,1)) <> "П" Или СтрДлина(ИмяПоказателя) < 13 Тогда
		Возврат Неопределено
	КонецЕсли;	
	
	Возврат Сред(ИмяПоказателя, 12, 2)
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Расчет итогов в документах

// Возвращает структуру, описывающую реквизит по которому рассчитывается итог табличной части
//
// Параметры:
//		ИмяРеквизита
//		Пояснение - Строка, используется при формировании расшифровки составляющей итоговой суммы
//
// Возвращаемое значение:
//		Структура
//			* ИмяРеквизита
//			* Пояснение
//
Функция ИтогиТабличныхЧастейОписаниеСуммируемогоРеквизита(ИмяРеквизита, Пояснение) Экспорт
	
	Возврат Новый Структура("ИмяРеквизита,Пояснение", ИмяРеквизита, Пояснение);
	
КонецФункции

// Возвращает структуру, описывающую табличную часть для расчета итогов
//
// Параметры:
//		ПутьКДанным
//		ОписанияРеквизитов - Массив описаний реквизитов, см.ИтогиТабличныхЧастейОписаниеСуммируемогоРеквизита
//
// Возвращаемое значение:
//		Структура
//			* ПутьКДанным
//			* ОписанияРеквизитов
//
Функция ИтогиТабличныхЧастейОписаниеТабличнойЧасти(ПутьКДанным, ОписанияРеквизитов) Экспорт
	
	Возврат Новый Структура("ПутьКДанным,ОписанияРеквизитов", ПутьКДанным, ОписанияРеквизитов);
	
КонецФункции

// Заполняет значение реквизита, содержащего итоговую сумму по табличным частям формы. Устанавливает
// подсказку с расшифровкой полученного итога.
//
// Параметры:
//		Форма
//		ИмяРеквизитаИтог
//		КоллекцияИтогов - Массив описаний табличных частей по которым рассчитывается итог
//						см.ИтогиТабличныхЧастейОписаниеТабличнойЧасти 
//
Процедура ИтогиТабличныхЧастейРассчитатьИтог(Форма, ИмяРеквизитаИтог, КоллекцияИтогов) Экспорт
	
	Итог = 0;
	ТекстПодсказки = "";
	
	СписокПодсказок = Новый СписокЗначений;
	МаксимальнаяДлиннаПояснения = 0;
	МаксимальнаяДлиннаПредставлениеИтога = 0;
	
	Для каждого ОписаниеИтоговТабличнойЧасти Из КоллекцияИтогов Цикл
		
		ДанныеТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеИтоговТабличнойЧасти.ПутьКДанным);;
		Для каждого ОписаниеКолонки Из ОписаниеИтоговТабличнойЧасти.ОписанияРеквизитов Цикл
			
			ИтогПоКолонке = ДанныеТабличнойЧасти.Итог(ОписаниеКолонки.ИмяРеквизита);
			Если ИтогПоКолонке <> 0 Тогда
				
				Итог = Итог + ИтогПоКолонке;
				
				ПредставлениеИтогаПоКолонке = Формат(ИтогПоКолонке, "ЧЦ=15; ЧДЦ=2");
				
				ОписаниеПодсказки = Новый Структура;
				ОписаниеПодсказки.Вставить("ПредставлениеИтога", ПредставлениеИтогаПоКолонке);
				
				ДлинаПояснения = СтрДлина(ОписаниеКолонки.Пояснение);
				ДлинаПредставленияИтога = СтрДлина(ПредставлениеИтогаПоКолонке);
				
				ОписаниеПодсказки.Вставить("ОбщаяДлина",  ДлинаПояснения + ДлинаПредставленияИтога);
				
				МаксимальнаяДлиннаПояснения = Макс(МаксимальнаяДлиннаПояснения, ДлинаПояснения);
				МаксимальнаяДлиннаПредставлениеИтога = Макс(МаксимальнаяДлиннаПредставлениеИтога, ДлинаПредставленияИтога);
				
				СписокПодсказок.Добавить(ОписаниеПодсказки, ОписаниеКолонки.Пояснение);
					
			КонецЕсли;
				
		КонецЦикла;
		
	КонецЦикла;
	
	СписокПодсказок.СортироватьПоПредставлению();
	
	МаксимальнаяОбщаяДлинаПредставления = МаксимальнаяДлиннаПояснения + МаксимальнаяДлиннаПредставлениеИтога;
	ШаблонПробелов = "                               ";
	Для каждого ОписаниеПодсказки Из СписокПодсказок Цикл
		
		ТекстПодсказки = ?(ПустаяСтрока(ТекстПодсказки), "", ТекстПодсказки + Символы.ПС)
			+ ОписаниеПодсказки.Представление + ": "
			+ Лев(ШаблонПробелов, (МаксимальнаяОбщаяДлинаПредставления - ОписаниеПодсказки.Значение.ОбщаяДлина))
			+ ОписаниеПодсказки.Значение.ПредставлениеИтога;
			
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ИмяРеквизитаИтог, Итог);
	
	УстановитьРасширеннуюПодсказкуЭлементуФормы(Форма, ИмяРеквизитаИтог, ТекстПодсказки);
		
КонецПроцедуры

Процедура УстановитьРасширеннуюПодсказкуЭлементуФормы(Форма, ИмяЭлемента, ТекстПодсказки) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы <> Неопределено Тогда
		ЭлементФормы.РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
	КонецЕсли;
	
КонецПроцедуры

#Область КлючевыеРеквизитыЗаполненияФормы

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Механизм КлючевыеРеквизитыЗаполненияФормы
// Процедуры и функции для предупреждения об очистке таблиц формы при редактировании "ключевых" реквизитов
//
// Для работы механизма в форме должны быть определены экспортные процедуры: 
// 		КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении()
// 		КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов()
//

// Процедура определяет нужно ли отображать предупреждение при редактировании для ключевых реквизитов формы 
Процедура КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(Форма, ОтображатьПредупреждение = Неопределено, МассивОписанийРеквизитов = Неопределено, МассивИменТаблиц = Неопределено) Экспорт
	
	Если ОтображатьПредупреждение = Неопределено Тогда
		Если МассивИменТаблиц = Неопределено Тогда 
			МассивИменТаблиц = Форма.КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении();
		КонецЕсли;	
		ОтображатьПредупреждение = КлючевыеРеквизитыЗаполненияФормыОтображатьПредупреждениеПриРедактировании(Форма, МассивИменТаблиц);
	КонецЕсли;
	
	Если МассивОписанийРеквизитов = Неопределено Тогда 
		МассивОписанийРеквизитов = Форма.КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов();
	КонецЕсли;	
	Для каждого Описание Из МассивОписанийРеквизитов Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			Описание.ЭлементФормы,
			"ОтображениеПредупрежденияПриРедактировании",
			ОтображатьПредупреждение);
	КонецЦикла;
КонецПроцедуры

// Функция определяет есть ли данные в таблицах документа, подключенных к механизму
Функция КлючевыеРеквизитыЗаполненияФормыОтображатьПредупреждениеПриРедактировании(Форма, МассивИменТаблиц)
	ОтображатьПредупреждениеПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	Для каждого ИмяТаблицы Из МассивИменТаблиц Цикл
		Таблица  = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ИмяТаблицы);
		Если Таблица.Количество() > 0 Тогда
			ОтображатьПредупреждениеПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат ОтображатьПредупреждениеПриРедактировании;
КонецФункции

#КонецОбласти

// Переносит отборы, переданные в параметрах открытия формы динамического списка
// в пользовательские настройки
//
// Параметры:
//		ДинамическийСписок	- ДинамическийСписок, реквизит формы
//		Параметры			- Структура, параметры формы динамического списка
//
Процедура НастроитьОтборыПараметровФормыСписка(ДинамическийСписок, Параметры) Экспорт
	
	Для каждого ОписаниеОтбора Из Параметры.Отбор Цикл
		
		// Проверка существования поля отбора
		Если ДинамическийСписок.КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.НайтиПоле(
				Новый ПолеКомпоновкиДанных(ОписаниеОтбора.Ключ)) = Неопределено Тогда
				
			Продолжить;
			
		КонецЕсли; 
		
		Представление = Неопределено;
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		
		// Определение представления и режима отображения существующего элемента отбора
		ЭлементыОтбораДинамическогоСписка = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
			ДинамическийСписок.КомпоновщикНастроек.Настройки.Отбор, ОписаниеОтбора.Ключ);
			
		Если ЭлементыОтбораДинамическогоСписка.Количество() > 0 Тогда
			Представление = ЭлементыОтбораДинамическогоСписка[0].Представление;
			РежимОтображения = ЭлементыОтбораДинамическогоСписка[0].РежимОтображения;
		КонецЕсли; 
		
		// Определение параметров отбора, содержащих коллекции значений
		ЗначениеОтбора = ОписаниеОтбора.Значение;
		ТипЗначения = ТипЗнч(ЗначениеОтбора);
		Если ТипЗначения = Тип("Массив")
			ИЛИ ТипЗначения = Тип("ФиксированныйМассив")
			ИЛИ ТипЗначения = Тип("СписокЗначений") Тогда
			
			ВидСравненияЗначения = ВидСравненияКомпоновкиДанных.ВСписке;
			
			Если ТипЗначения = Тип("Массив")
				ИЛИ ТипЗначения = Тип("ФиксированныйМассив") Тогда
				
				СписокЗначенийОтбора = Новый СписокЗначений;
				Если ТипЗначения = Тип("Массив") Тогда
					СписокЗначенийОтбора.ЗагрузитьЗначения(ЗначениеОтбора);
				Иначе
					СписокЗначенийОтбора.ЗагрузитьЗначения(Новый Массив(ЗначениеОтбора));
				КонецЕсли;
				
				ЗначениеОтбора = СписокЗначенийОтбора;
				
			КонецЕсли;
			
		Иначе
			ВидСравненияЗначения = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		
		// Установка параметра отбора
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ДинамическийСписок.КомпоновщикНастроек.Настройки.Отбор,
			ОписаниеОтбора.Ключ,
			ЗначениеОтбора,
			ВидСравненияЗначения,
			Представление,
			Истина,
			РежимОтображения);
			
		// Удаление, настроенного параметра отбора
		Параметры.Отбор.Удалить(ОписаниеОтбора.Ключ);
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ДатаОтсчетаПериодическихСведений() Экспорт
	
	Возврат '18991231000000';
	
КонецФункции

Функция ДатаОтсчетаПериодическихСведенийСПериодомМесяц() Экспорт
	
	Возврат КонецМесяца(ДатаОтсчетаПериодическихСведений()) + 1;
	
КонецФункции

Функция СоответствиеДанныхФизЛицаДаннымДокумента(ТипДокумента)
	
	СтруктураСоответствия = Новый Структура();
	СтруктураСоответствия.Вставить("Фамилия", "Фамилия");
	СтруктураСоответствия.Вставить("Имя", "Имя");
	СтруктураСоответствия.Вставить("Отчество", "Отчество");
	СтруктураСоответствия.Вставить("СтраховойНомерПФР", "СтраховойНомерПФР");
	СтруктураСоответствия.Вставить("Пол", "Пол");	
	СтруктураСоответствия.Вставить("ДатаРождения", "ДатаРождения");
	СтруктураСоответствия.Вставить("МестоРождения", "МестоРождения");
	СтруктураСоответствия.Вставить("МестоРожденияПредставление", "МестоРожденияПредставление");
	СтруктураСоответствия.Вставить("АдресРегистрацииПредставление", "АдресРегистрацииПредставление");
	СтруктураСоответствия.Вставить("АдресФактическийПредставление", "АдресФактическийПредставление");
	СтруктураСоответствия.Вставить("АдресДляИнформированияПредставление", "АдресДляИнформированияПредставление");
	СтруктураСоответствия.Вставить("АдресРегистрации", "АдресРегистрации");
	СтруктураСоответствия.Вставить("АдресФактический", "АдресФактический");
	СтруктураСоответствия.Вставить("АдресДляИнформирования", "АдресДляИнформирования");
	СтруктураСоответствия.Вставить("Гражданство", "Гражданство");
	СтруктураСоответствия.Вставить("Телефоны", "Телефоны");
	СтруктураСоответствия.Вставить("ИНН", "ИНН");
	
	СтруктураСоответствия.Вставить("ВидДокумента", "ВидДокумента");
	СтруктураСоответствия.Вставить("Серия", "СерияДокумента");
	СтруктураСоответствия.Вставить("Номер", "НомерДокумента");
	СтруктураСоответствия.Вставить("ДатаВыдачи", "ДатаВыдачи");
	СтруктураСоответствия.Вставить("КемВыдан", "КемВыдан");
	СтруктураСоответствия.Вставить("СтатусНалогоплательщика", "СтатусНалогоплательщика");
	
	Возврат СтруктураСоответствия;
	
КонецФункции

// Процедура вызывается в форме, содержащей данные физического лица при изменении данных физического лица.
// Например, для отработки оповещения о записи нового состояния физлица
// Параметры:
//		Объект - данные формы в которой выполняется редактирование
//		ДанныеФизическогоЛица - новое состояние физического лица. Структура с полями, совпадающими по именам с полями данных формы
//
Процедура ОбработкаИзмененияДанныхФизическогоЛица(Объект, ДанныеФизическогоЛица, СтрокиПоСотруднику, Модифицированность = Ложь) Экспорт
	Перем ИмяПоляВДокументе, ЗначениеСвойстваСотрудника;
	ТипДокумента = ТипЗнч(Объект.Ссылка);
	
	СоответствиеДанных = СоответствиеДанныхФизЛицаДаннымДокумента(ТипДокумента);
	Для Каждого СтрокаСотрудника Из СтрокиПоСотруднику Цикл
		Для Каждого КлючЗначение Из ДанныеФизическогоЛица Цикл
			Если СоответствиеДанных.Свойство(КлючЗначение.Ключ, ИмяПоляВДокументе) Тогда
				
				ДанныеСтрокиСотрудника = Новый Структура;
				ДанныеСтрокиСотрудника.Вставить(ИмяПоляВДокументе);
				ЗаполнитьЗначенияСвойств(ДанныеСтрокиСотрудника, СтрокаСотрудника);
				Если ДанныеСтрокиСотрудника[ИмяПоляВДокументе] <> Неопределено Тогда
					Если ЗначениеСвойстваСотрудника <> КлючЗначение.Значение Тогда
						Модифицированность = Истина;
						СтрокаСотрудника[ИмяПоляВДокументе] = КлючЗначение.Значение;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

	
